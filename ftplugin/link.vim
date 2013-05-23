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
					let fn = substitute(fn,"#","\\\\#","")	" escape hash
					let fn = substitute(fn,"%","\\\\%","")	" escape percent
					execute "silent !start explorer.exe ".fn
				elseif (match(fn,".pdf") != -1)
					execute "silent !start explorer.exe ".fn
				elseif (match(fn,"#") != -1)
					" this is a file with an "anchor",
					" i.e. a mark to follow

					execute "e ".fn
					
				else " if unmatched, try editing as a text file
					execute "e ".fn
				endif

				" clear the variables here
				unlet fn
				unlet fnr

				" and clear the unnamed register (from yi[)
				let @"=''
			endif
		endfunction
endif

" function to facilitate link creation
if !exists("*CreateLink")
	function! CreateLink()
		"let link = input("Enter link: ")
		"if (strlen(link) != 0)
		"	let text = input("Enter display text: ")
		"	execute ":normal a [[".link."|".text."]] "
		"endif
		"
		"create brackets for linking
		normal a [[]]

		" get inside and start typing
		normal hh % 
		startinsert
	endfunction
endif

nnoremap <c-cr> :call LinkForward()<cr>
nnoremap <leader>l :call CreateLink()<cr>

" commented out... just use Ctrl+o
"if !exists("*LinkBackward")
"	function! LinkBackward()
"		execute "e ".g:fromFile
"	endfunction
"endif
"nnoremap <bs> :call LinkBackward()<cr>
