" Allow math conceal inside siunitx \qty/\SI number arguments in text mode.
if exists('*vimtex#syntax#core#new_arg')
  " Redefine siunitx number-with-unit argument to include math cluster.
  silent! syntax clear texSIArgNumU
  call vimtex#syntax#core#new_arg('texSIArgNumU', {
        \ 'contains': 'texSIDelim,@texClusterMath',
        \ 'next': 'texSIArgUnit',
        \ })

  " Redefine range-number argument to include math cluster too.
  silent! syntax clear texSIArgNumNU
  call vimtex#syntax#core#new_arg('texSIArgNumNU', {
        \ 'contains': 'texSIDelim,@texClusterMath',
        \ 'next': 'texSIArgNumU',
        \ })
endif
