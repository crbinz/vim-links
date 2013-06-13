" added by C Binz
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
					let fn = substitute(fn,"#","\\\\#","")	" escape hash
					let fn = substitute(fn,"%","\\\\%","")	" escape percent
					execute cmd.fn
				elseif (match(fn,".pdf") != -1)
					execute cmd.fn
				elseif (match(fn,"#") != -1)
					" this is a file with an "anchor",
					" i.e. a mark to follow
					" split into the file name and the
					" mark
					let mn = substitute(fn,".*#","","")	" mark only
					let fn = substitute(fn,"#.*","","")	" file name only
					
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

				" and clear the unnamed register (from yi[)
				let @"=''
			endif
		endfunction
endif

" function to facilitate link creation
if !exists("*CreateLink")
	function! CreateLink(in)
		"do it with prompts
		let link = input("Enter link: ")
		if (strlen(link) != 0)
			let text = input("Enter display text: ")
			execute ":normal a[[".link."|".text."]] "
		endif

		if a:in == "1"
			startinsert
		endif
		"
		"create brackets for linking, along with a guide
		"normal a [[<file or URL>{#<mark>}|<link text>]]

		" move over one bracket, select inside
		"normal hvi[

	endfunction
endif

" mappings
nnoremap <c-cr> :call LinkForward()<cr>
nnoremap <localleader>l :call CreateLink(0)<cr>
inoremap <localleader>l ~<esc>x:call CreateLink(1)<cr>

" commented out... just use Ctrl+o
"if !exists("*LinkBackward")
"	function! LinkBackward()
"		execute "e ".g:fromFile
"	endfunction
"endif
"nnoremap <bs> :call LinkBackward()<cr>
