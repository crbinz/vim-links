" nvlinks autoload file
" Maintainer: Marc Patton <pattonmj8503@gmail.com>

function! nvlinks#check_for_nv_dir()
  if exists('g:nv_main_directory')
    return g:nv_main_directory
  elseif exists('g:nv_search_paths')
    for path in g:nv_search_paths
      if isdirectory(path)
        return path
      endif
    endfor
  else
    return ''
  endif
endfunction


function nvlinks#check_for_nvlinks_dir()
  if exists('g:nvlinks_notes_dir')
    return g:nvlinks_notes_dir
  else
    return ''
  endif
endfunction
  
