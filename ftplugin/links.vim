" added by C Binz
"TODO:  Implement syntax concealment - DONE
" Check whether word under cursor is a link or not  

function! FollowLink()
  "first, we need to account for links with multiple words
  "going to guess that if the WORD can be found inside brackets, it's a link
  let pos = getpos(".")
  normal! T[
  let new_pos = getpos(".")

  "going to guess that, if we're in the same spot after the above motion, this 
  "is NOT a link, so leave this function
  "of course, this won't cover the goofy case of having a single character as a
  "link...
  if (pos[2] == new_pos[2])
    return
  endif

  let test = expand("<cWORD>")  
  if (match(test,"[[") == 0)  " word starts with double brackets
    let saved_register_data = @"
    normal! yi[
    let fnr = @"
    let fnr = substitute(fnr,"\[","","")  " strip leading bracket if it exists
    let fnr = substitute(fnr,"\]","","")  " strip trailing bracket if it exists
    let fn = substitute(fnr,"\|.*","","")
    echo fnr

    " check for OS, construct commands accordingly
    if has("win32") || has("win64")
      let cmd = "silent !start explorer.exe "
    elseif has("mac")
      let cmd = "silent !open "
    endif

    " different rules for different filetypes - URLs and PDFs
    if (strlen(fn) == 0)
    " do nothing
    elseif (match(fn,"http") == 0)
      let fn = substitute(fn,"#","\\\\#","")  " escape hash
      let fn = substitute(fn,"%","\\\\%","")  " escape percent
      execute cmd.fn
    elseif (match(fn,".pdf") != -1)
      execute cmd.fn
    elseif (match(fn,"#") != -1)
      " this is a file with an "anchor",
      " i.e. a mark to follow
      " split into the file name and the
      " mark
      let mn = substitute(fn,".*#","","") " mark only
      let fn = substitute(fn,"#.*","","") " file name only
      
      echo mn
      echo fn

      execute "e ".fn
      execute "'".mn
      
    else " if unmatched, try editing as a text file
      execute "e ".fn
    endif

    " clear the variables here
    unlet fn
    unlet fnr

    "restore the unnamed register
    let @" = saved_register_data
  endif
endfunction

" mappings
nnoremap <cr> :call FollowLink()<cr>
" surround visually selected text with link brackets
" vnoremap <silent> <C-l> <esc>`<i[[<esc>`>a]]<esc>
"inoremap <localleader>l ~<esc>x:call CreateLink(1)<cr>

" commented out... just use Ctrl+o
"if !exists("*LinkBackward")
" function! LinkBackward()
"   execute "e ".g:fromFile
" endfunction
"endif
"nnoremap <bs> :call LinkBackward()<cr>
