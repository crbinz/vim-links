##Vim plugin to create in-line links to files or URLs.

###Installation
Simply clone vim-links into your bundle/ directory (if using Pathogen), then add the following lines to your vimrc:
```
autocmd FileType <file type> setlocal filetype+=.links
```
For each `<file type>` you want vim-links active in. You should also have `set conceallevel=2` and `set concealcursor=nc` in your .vimrc (see `:h conceal` for more).

###Use
The format of a link is
```
[[<link> | <link text>]]
```
Once a pattern matching this is found, vim-links conceals everything but the link text. Links can be: 
	* URLs
	* Absolute file paths (i.e. /home/user/note.txt)
	* Relative file paths (i.e. ./note.txt)
Links to non-text files are, in general, hit-or-miss. Currently .pdf files work well.

To open a link, position the cursor over it and press <kbd>CTRL</kbd>+<kbd>ENTER</kdb>.

To create a link, you can either manually input it in the format above, or use the mapping `<localleader>l`, which will prompt you for the link and the link text.
