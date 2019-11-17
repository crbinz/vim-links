" NVLinks plugin file

if exists('g:loaded_nvlinks_plugin')
  finish
endif
let g:loaded_nvlinks_plugin = 1

let s:notes_dir = nvlinks#check_for_notes_dir()

if s:notes_dir ==# ''
  echoerr 'Please define one of the following: '
    \. 'g:nv_main_directory, '
    \. 'g:nv_search_paths, '
    \. 'g:nvlinks_notes_dir'
  finish
endif

let s:cmd_pattern = expand(s:notes_dir) . '/* set filetype+=.nvlinks'

" this will add the links syntax to all files under the main directory where
" user notes are kept
augroup nvlinks
  autocmd!
  execute 'autocmd BufRead,BufNewFile ' . s:cmd_pattern
augroup END

