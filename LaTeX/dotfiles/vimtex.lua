return {
	{
 	 "lervag/vimtex",
  	lazy = false,
  	init = function()
    	vim.g.vimtex_view_method = "skim"
    	
    	-- TOC config
    	vim.g.vimtex_toc_config = {
      	split_pos = 'topleft',
      	split_width = 6,
    	}
    	
    	-- Enable folding with robust settings
    	vim.g.vimtex_fold_enabled = 1
    	vim.g.vimtex_fold_manual = 0
    	vim.g.vimtex_fold_levelmarker = '◉'
    	
    	local function refcom_command_end(line)
      	local _, finish = line:find("^%s*\\refcom%*")
      	if not finish then
        	_, finish = line:find("^%s*\\refcom")
      	end
      	if not finish then
        	return nil
      	end

      	local next_char = line:sub(finish + 1, finish + 1)
      	if next_char:match("%a") then
        	return nil
      	end

      	return finish
    	end

    	local function scan_refcom_args(line, state, start_col)
      	local escaped = false

      	for i = start_col or 1, #line do
        	local char = line:sub(i, i)

        	if escaped then
          	escaped = false
        	elseif char == "\\" then
          	escaped = true
        	elseif char == "%" then
          	break
        	elseif char == "{" then
          	state.depth = state.depth + 1
        	elseif char == "}" and state.depth > 0 then
          	state.depth = state.depth - 1
          	if state.depth == 0 then
            	state.groups = state.groups + 1
          	end
        	end
      	end
    	end

    	local function refcom_state_through(start_lnum, end_lnum)
      	local state = { depth = 0, groups = 0 }

      	for lnum = start_lnum, end_lnum do
        	local line = vim.fn.getline(lnum)
        	local start_col = 1
        	if lnum == start_lnum then
          	local command_end = refcom_command_end(line)
          	if not command_end then
            	return state
          	end
          	start_col = command_end + 1
        	end

        	scan_refcom_args(line, state, start_col)
      	end

      	return state
    	end

    	local function find_refcom_start(lnum)
      	for current = lnum, 1, -1 do
        	if refcom_command_end(vim.fn.getline(current)) then
          	return current
        	end
      	end

      	return nil
    	end

    	local function refcom_fold_level(line, lnum)
      	local command_end = refcom_command_end(line)
      	if command_end then
        	local state = { depth = 0, groups = 0 }
        	scan_refcom_args(line, state, command_end + 1)

        	if state.groups >= 3 and state.depth == 0 then
          	return ""
        	end

        	return "a1"
      	end

      	if not line:match("^%s*[{}]") then
        	return ""
      	end

      	local start_lnum = find_refcom_start(lnum)
      	if not start_lnum then
        	return ""
      	end

      	local state = refcom_state_through(start_lnum, lnum)
      	if state.groups >= 3 and state.depth == 0 then
        	return "s1"
      	end

      	return ""
    	end

    	local function refcom_title_from_fold()
      	local fold_start = tonumber(vim.v.foldstart) or vim.fn.line(".")
      	local fold_end = tonumber(vim.v.foldend) or fold_start
      	local lines = vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_end, false)
      	local title = {}
      	local collecting = false
      	local found_command = false
      	local depth = 0

      	for _, line in ipairs(lines) do
        	local start_col = 1
        	if not collecting and not found_command then
          	local command_end = refcom_command_end(line)
          	if not command_end then
            	goto continue
          	end
          	found_command = true
          	start_col = command_end + 1
        	end

        	local escaped = false
        	for i = start_col, #line do
          	local char = line:sub(i, i)

          	if escaped then
            	if collecting then
              	table.insert(title, char)
            	end
            	escaped = false
          	elseif char == "\\" then
            	if collecting then
              	table.insert(title, char)
            	end
            	escaped = true
          	elseif char == "%" then
            	break
          	elseif not collecting and char == "{" then
            	collecting = true
            	depth = 1
          	elseif collecting and char == "{" then
            	depth = depth + 1
            	table.insert(title, char)
          	elseif collecting and char == "}" then
            	depth = depth - 1
            	if depth == 0 then
              	return table.concat(title)
            	end
            	table.insert(title, char)
          	elseif collecting then
            	table.insert(title, char)
          	end
        	end

        	if collecting then
          	table.insert(title, " ")
        	end

        	::continue::
      	end

      	return nil
    	end

    	_G.vimtex_refcom_fold_text = function()
      	if vim.bo.filetype == "bib" then
        	if vim.fn.exists("*vimtex#fold#bib#text") == 1 then
          	return vim.fn["vimtex#fold#bib#text"]()
        	end
        	return vim.fn.foldtext()
      	end

      	local line = vim.fn.getline(vim.v.foldstart)
      	if not refcom_command_end(line) then
        	return vim.fn["vimtex#fold#text"]()
      	end

      	local title = refcom_title_from_fold()
      	if not title then
        	return line
      	end

      	title = title:gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", " ")
      	if title == "" then
        	return line
      	end

      	if vim.fn.exists("*vimtex#parser#tex#texorpdfstring") == 1 then
        	title = vim.fn["vimtex#parser#tex#texorpdfstring"](title)
      	end

      	local width = math.max(vim.api.nvim_win_get_width(0) - 7, 10)
      	title = vim.fn.strcharpart(title, 0, width)

      	return string.format("%-5s %s", "", title:gsub("%s+$", ""))
    	end

    	vim.api.nvim_create_autocmd("User", {
      	pattern = "VimtexEventInitPost",
      	callback = function()
        	if not vim.tbl_contains({ "tex", "plaintex", "latex" }, vim.bo.filetype) then
          	return
        	end

        	vim.opt_local.foldtext = "v:lua.vimtex_refcom_fold_text()"
        	if vim.b.vimtex and vim.b.vimtex.fold_re then
          	vim.b.vimtex.fold_re = vim.b.vimtex.fold_re .. "|^\\s*{"
        	end
      	end,
    	})

    	-- More comprehensive fold configuration
    	vim.g.vimtex_fold_types = {
      	preamble = {
        	enabled = 1,
      	},
      	envs = {
        	enabled = 1,
        	whitelist = {},  -- Empty = fold ALL environments including nested ones
      	},
      	sections = {
        	enabled = 1,
        	parse_levels = 1,
        	sections = {
        	'part',
        	'chapter',
        	'section',
        	'subsection',
        	'subsubsection',
        	},
      	},
      	comments = {
        	enabled = 1,
      	},
      	markers = {
        	enabled = 0,
      	},
      	cmd_single = {
        	enabled = 0,
      	},
      	cmd_multi = {
        	enabled = 1,
        	cmds = { "refcom" },
        	level = refcom_fold_level,
      	},
      	cmd_addplot = {
        	enabled = 0,
      	},
      	items = {
        	enabled = 0,  -- Don't fold individual items
      	},
    	}
    	
    	local minitoc_clean = [[-e '$clean_ext .= " %R.mtc %R.mtc* %R.mta %R.maf %R.mlf"']]

    	-- Set LuaLaTeX as compiler
    	vim.g.vimtex_compiler_latexmk = {
      	options = {
        	'-verbose',
        	'-file-line-error',
        	'-synctex=1',
        	'-interaction=nonstopmode',
        	minitoc_clean,
      	},
    	}
    	
    	-- Function to switch compiler
    	_G.switch_latex_compiler = function(engine)
      	if engine == 'lualatex' then
        	vim.g.vimtex_compiler_latexmk.options = {
          	'-lualatex',
       	  '-verbose',
          	'-file-line-error',
          	'-synctex=1',
          	'-interaction=nonstopmode',
          	minitoc_clean,
        	}
      	elseif engine == 'pdflatex' then
        	vim.g.vimtex_compiler_latexmk.options = {
          	'-pdf',
          	'-verbose',
          	'-file-line-error',
          	'-synctex=1',
          	'-interaction=nonstopmode',
          	minitoc_clean,
        	}
      	elseif engine == 'xelatex' then
        	vim.g.vimtex_compiler_latexmk.options = {
          	'-xelatex',
          	'-verbose',
          	'-file-line-error',
          	'-synctex=1',
          	'-interaction=nonstopmode',
          	minitoc_clean,
        	}
      	end
      	vim.cmd('VimtexStop')
      	print("LaTeX compiler set to: " .. engine)
    	end
    	
    	-- Commands to switch compilers
    	vim.api.nvim_create_user_command('VimtexCompilerLuaLaTeX', function()
      	switch_latex_compiler('lualatex')
    	end, {})
    	
    	vim.api.nvim_create_user_command('VimtexCompilerPDFLaTeX', function()
      	switch_latex_compiler('pdflatex')
    	end, {})
    	
    	vim.api.nvim_create_user_command('VimtexCompilerXeLaTeX', function()
      	switch_latex_compiler('xelatex')
    	end, {})
 	end
	}
}
