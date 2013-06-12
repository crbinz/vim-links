" vimwiki-style folding
" match a vimwiki-style link
" use this with set: conceallevel=2 in vimrc
"NOTE: escaping is weird in Vim...

" define highlight styles
hi outlLink term=underline cterm=underline ctermfg=9 gui=underline guifg=#80a0ff

syn match outlLink '\[\[' conceal 	"beginning of a bare link
syn match outlLink /\[\[[^]|]*|/ conceal"beginning of a renamed link
syn match outlLink '\]\]' conceal	"end
"syn match outlLink '\[\[.\+\]\]' contains=outlLink "change highlighting of entire link
syn match outlLink '\[\[.\{-}\]\]' contains=outlLink "change highlighting of entire link

