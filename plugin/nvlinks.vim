" NVLinks plugin file
" Maintainer: Marc Patton <pattonmj8503@gmail.com>

if exists('g:loaded_nvlinks_plugin')
  finish
endif
let g:loaded_nvlinks_plugin = 1

let s:notes_dir = nvlinks#check_for_nv_dir()

if s:notes_dir ==# ''
  let s:notes_dir = nvlinks#check_for_nvlinks_dir()
endif

" this will add the links syntax to all files under the main directory where
" user notes are kept
augroup nvlinks
  autocmd!
  execute 'autocmd BufRead,BufNewFile ' . s:notes_dir . '/* set filetype+=.nvlinks'
augroup END

