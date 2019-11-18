" nvlinks autoload file

function! nvlinks#check_for_notes_dir()
  if exists('g:nv_main_directory')
    return g:nv_main_directory
  elseif exists('g:nv_search_paths')
    for path in g:nv_search_paths
      if isdirectory(expand(path))
        return path
      endif
    endfor
  elseif exists('g:nvlinks_notes_dir')
    return g:nvlinks_notes_dir
  endif

  return ''
endfunction


" notational-fzf-vim defines a single command.  check for it to determine if
" the plugin is installed
function! nvlinks#is_nv_present()
  if exists(':NV')
    return 1
  endif

  return 0
endfunction


function! nvlinks#handle_link()
  let move_cursor_to_new_window = get(g:, 'nvlinks_move_to_new_window', 1)
  let link_text_re ='\[\[\zs[^\\\]]\{-}\ze\]\]' 
  let lnk = matchstr(nvlinks#matchstr_at_cursor(), link_text_re)
  let nv_present = nvlinks#is_nv_present()
  let search = get(g:, 'nvlinks_search_first', 0)

  if lnk != ''
    " the search settings only matter if notational-fzf-vim is installed
    if nv_present && search
      let search_full_screen = get(g:, 'nvlinks_search_full_screen', 1)
      let cmd = nvlinks#get_search_cmd(search_full_screen)
    else
      let split = get(g:, 'nvlinks_split_option', 'none')
      let cmd = nvlinks#get_open_cmd(split, 0)
    endif
  endif
  
  let current_tab_page = tabpagenr()

  call nvlinks#open_link(cmd, lnk, search)

  if !move_cursor_to_new_window
    if (split ==# 'hsplit' || split ==# 'vsplit')
      execute 'wincmd p'
    elseif split ==# 'tab'
      execute 'tabnext ' . current_tab_page
    endif
  endif
endfunction


function! nvlinks#get_search_cmd(full_screen)
  let cmd = ':NV'

  if a:full_screen
    let cmd = cmd . '! '
  else
    let cmd = cmd . ' '
  endif

  return cmd
endfunction


function! nvlinks#get_open_cmd(split, ...)
  let reuse_other_split_window = a:0 >= 1 ? a:1 : 0
  
  if a:split ==# 'hsplit'
    let cmd = ':split '
  elseif a:split ==# 'vsplit'
    let cmd = ':vsplit '
  elseif a:split ==# 'tab'
    let cmd = ':tabnew '
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

  return cmd
endfunction


function! nvlinks#matchstr_at_cursor()
  let link_re = '\[\[[^\\\]]\{-}\]\]'
  let col = col('.') - 1
  let line = getline('.')
  let ebeg = -1
  let cont = match(line, link_re, 0)

  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, link_re, cont)
    
    if (cont <= col) && (col < contn)
      let ebeg = match(line, link_re, cont)
      let elen = contn - ebeg
      break
    else
      let cont = match(line, link_re, contn)
    endif
  endwh

  if ebeg >= 0
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
  let lnk = a:link
  let open_for_search = a:0 > 0 ? a:1 : 0
  let notes = expand(nvlinks#check_for_notes_dir())
  let save_on_transition = get(g:, 'nvlinks_save_on_transition', 1)
  
  if !open_for_search
    if exists('g:nv_default_extension')
      let note_ext = g:nv_default_extension
    else
      let note_ext = get(g:, 'nvlinks_note_ext', '.md')
    endif

    if !match(lnk, '\.'. note_ext . '$')
      lnk = lnk . note_ext
    endif

    if notes[-1] ==# '/'
      let lnk = notes . lnk
    else
      let lnk = notes . '/' . lnk
    endif

    " Escape the path first in case there are any weird characters
    let lnk = fnameescape(lnk)
  endif

  " This bit should let us go to the link target by 'autosaving' before
  " traversal
  if save_on_transition
    if &modified
      normal! :w<cr>
    endif
  endif

  execute a:cmd . lnk
endfunction

