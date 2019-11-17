" NVLinks filetype plugin file

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = 'setlocal buftype='

" commands
command! -buffer NVLinksHandleLink call nvlinks#handle_link()
