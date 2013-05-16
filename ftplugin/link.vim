" added by C Binz
" trying to get support for linking similar to vimwiki
" credit user "Kent" on StackOverflow
"TODO:  Implement syntax concealment - DONE
"	Check whether word under cursor is a link or not	

" outer if wrapper checks to make sure function is not being redefined
if !exists("*LinkForward")
		function! LinkForward()
			let test = expand("<cWORD>")	
			if (match(test,"[[") == 0)	" word starts with double brackets
				normal yi[
				let fnr = @"

				let fnr = substitute(fnr,"\[","","")	" strip leading bracket if it exists
				let fnr = substitute(fnr,"\]","","")	" strip trailing bracket if it exists
				let fn = substitute(fnr,"\|.*","","")
				echo fnr

				" different rules for different filetypes - URLs and PDFs
				if (strlen(fn) == 0)
				" do nothing
				elseif (match(fn,"http") == 0)
					execute "silent !start explorer.exe ".fn
				elseif (match(fn,".pdf") != -1)
					execute "silent !start explorer.exe ".fn
				else " if unmatched, try editing as a text file, in a new tab
					execute "tabe ".fn
				endif

				" clear the variables here
				unlet fn
				unlet fnr

				" and clear the unnamed register (from yi[)
				let @"=''
			endif
		endfunction
endif

nnoremap <cr> :call LinkForward()<cr>

" commented out... just use Ctrl+o
"if !exists("*LinkBackward")
"	function! LinkBackward()
"		execute "e ".g:fromFile
"	endfunction
"endif
"nnoremap <bs> :call LinkBackward()<cr>
