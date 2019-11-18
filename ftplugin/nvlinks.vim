" NVLinks filetype plugin file

" since the 'nvlinks' file type should only be appended to an existing file
" type, the variable `b:did_ftplugin` will likely have already been set by the
" first ftplugin (e.g. markdown).  instead of using that, use a unique
" variable to determine if _this_ one has been loaded.
if exists('b:did_nvlinks_ftplugin') 
  finish 
endif 
let b:did_nvlinks_ftplugin = 1

let b:undo_ftplugin = 'setlocal buftype='

" commands
command! -buffer NVLinksHandleLink call nvlinks#handle_link()
