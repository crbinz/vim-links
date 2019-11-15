" NVLinks filetype plugin file

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = 'setlocal buftype='

let s:link_re = '\[\[[^\\\]]\{-}\]\]'
let s:link_text_re = '\[\[\zs[^\\\]]\{-}\ze\]\]'
let s:search_first = get(g:, nvlinks_search_first, 0)
let s:full_screen_search = get(g:, nvlinks_full_screen_search, 1)
let s:save_on_transition = get(g:, nvlinks_save_on_transition, 1)
let s:split_option = get(g:, nvlinks_split_option, 'none')
let s:nv_present = 0 "assume notational-fzf-vim isn't here

" This bit may or may not be necessary
"if s:save_on_transition
"  setlocal autowriteall
"endif

" check for notational-fzf-vim settings
if exists('g:nv_default_extension')
  let s:note_ext = g:nv_default_extension
else
  let s:note_ext = get(g:, 'nvlinks_default_ext', '.md')
endif

let s:notes_dir = nvlinks#check_for_nv_dir()

" we're going to assume that if you have the notational-fzf-vim
" settings, you have the plugin installed.  what could go wrong with THAT
" assumption???
if s:notes_dir !=# ''
  let s:nv_present = 1
else
  " if s:notes_dir isn't set by now, check setting for this plugin
  let s:notes_dir = nvlinks#check_for_nvlinks_dir()
endif

" TODO: this... feels clunky.  fix soon please.
if s:notes_dir ==# ''
  echoerr 'Please define one of the following: '
    \. 'g:nv_main_directory, '
    \. 'g:nv_search_paths, '
    \. 'g:nvlinks_notes_dir'
  finish
endif

" disable these settings if notational-fzf-vim not detected
if !s:nv_present
  s:search_first = 0
  s:search_full_screen = 0
endif


function! nvlinks#follow_link(split, ...)
  let reuse_other_split_window = a:0 >= 1 ? a:1 : 0
  let move_cursor_to_new_window = a:0 >= 2 ? a:2 : 1
  let lnk = matchstr(nvlinks#matchstr_at_cursor(), s:link_text_re)

  if lnk != ''
    if a:split ==# 'hsplit'
      let cmd = ':split '
    elseif a:split ==# 'vsplit'
      let cmd = ':vsplit '
    elseif a:split ==# 'tab'
      let cmd = ':tabnew '
    elseif s:search_first:
      let cmd = ':NV'

      " you can add a ! to the :NV command to search in full screen
      if s:full_screen_search
        let cmd = cmd . '! '
      else
        let cmd = cmd . ' '
      endif
    else
      let cmd = ':e '
    endif

    if (a:split ==# 'hsplit' || a:split ==# 'vsplit') && reuse_other_split_window
      let previous_window_nr = winnr('#')
      
      if previous_window_nr > 0 && previous_window_nr != winnr()
        execute previous_window_nr . 'wincmd w'
        let cmd = ':e'
      endif
    endif

    let lnk = substitute(lnk, '\' . s:note_ext . '$', '', '')
  endif

  let current_tab_page = tabpagenr()

  call nvlinks#open_link(cmd, lnk)

  if !move_cursor_to_new_window
    if (a:split ==# 'hsplit' || a:split ==# 'vsplit')
      execute 'wincmd p'
    elseif a:split ==# 'tab'
      execute 'tabnext ' . current_tab_page
    endif
  endif

  " TODO: what to do with `lnk` now?
  " 1. Should we search with :NV, if it's available
  " 2. Should we just try to open the file
  " YES! We should!
endfunction


function! nvlinks#matchstr_at_cursor()
  let col = col('.') - 1
  let line = getline('.')
  let ebeg = -1
  let cont = match(line, s:link_re, 0)

  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, s:link_re, cont)
    
    if (cont <= col) && (col < contn)
      let ebeg = match(line, s:link_re, cont)
      let elen = contn - ebeg
      break
    else
      let cont = match(line, s:link_re, contn)
    endif
  endwh

  if egeg >= 0
    return strpart(line, ebeg, elen)
  else
    return ""
  endif
endfunction


" The link should be the name of a file, so we'll just try to open it in the
" notes directory.  
" TODO: Let the file extension be present or not in the link.  Right now, the
" extension is automatically appended, which could cause undesirable behavior
" if the extension is already there
function! nvlinks#open_link(cmd, link, ...)
  let cwd = getcwd()
  let notes = expand(s:notes_dir)
  
  if notes[-1] ==# '/'
    let link = notes . link . s:note_ext
  else
    let link = notes . '/' . link . s:note_ext
  endif

  " Escape the path first in case there are any weird characters
  let file_name = fnameescape(link)

  " This bit should let us go to the link target by "autosaving" before
  " traversal
  if s:save_on_transition
    if &modified
      normal! :w<cr>
    endif
  endif

  execute cmd . file_name 
endfunction


" commands
command! -buffer NVLinksFollowLink call nvlinks#follow_link(s:split_option, 0, 1)
