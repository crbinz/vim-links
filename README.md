# nvlinks

`nvlinks` is a relatively simple plugin that will allow you to add
[nvALT](https://brettterpstra.com/projects/nvalt/) style links to your notes.
This plugin is meant to complement
[notational-fzf-vim](https://github.com/alok/notational-fzf-vim), which is an
excellent plugin that mimics a lot nvALT functionality.  

## Background

I often tell people that nvALT changed my life, which is only the slightest of
exaggerations.  It certainly changed my professional life, greatly easing my
note-taking workflow.  The only issue is that it is only available on macOS,
which has started to factor heavily into my decision-making when it comes to
buying a new computer ("HOW WILL I ACCESS MY NOTES?!?!  HOW WILL I EVEN _TAKE_
NOTES?!?!").  As Vim is my text editor of choice, I started to look for a way to
add the functionality.  Eventually I came across the awesome
[notational-fzf-vim](https://github.com/alok/notational-fzf-vim), which covers
most of the bases that I use nvALT for.  However, the author made it clear that
the only functionality that was intended to be covered was searching and
creating notes.  I rely heavily on the ability to link notes and so I set out to
tackle that problem myself.

Of course, linking between notes is pretty much a solved problem with the likes
of [vimwiki](https://github.com/vimwiki/vimwiki), but that particular plugin has
a lot of other functionality that I don't necessarily need.  Plus, I was
becoming interested in Vimscript (having just read Steve Losh's [Learn Vimscript
the Hard Way](http://learnvimscriptthehardway.stevelosh.com/)).  So I decided to
make my own plugin, shamelessly stealing from vimwiki, adding and removing
things as necessary.  I also used a few ideas from another plugin that I thought
had most of what I needed ([vim-links](https://github.com/crbinz/vim-links)),
but that one wasn't as robust as what I wanted.  Perhaps the author wasn't done,
or perhaps it has all of the desired functionality.

## Installation

I've only tested with Vim 8's packages, but this _should_ be relatively
compatible with [Pathogen](https://github.com/tpope/vim-pathogen) as well, at
least.  

### Packages

```
$ git clone https://github.com/ironbars/nvlinks.git
~/.vim/pack/dist/start/nvlinks
```

Or whatever you call your Vim packages directory.

### Pathogen

Assuming you already have pathogen installed and working:  

```
$ cd ~/.vim/bundle
$ git clone https://github.com/ironbars/nvlinks.git
```

## Usage

The only thing that you must define in your `~/.vimrc` is one of the following:

* `g:nv_main_directory`
* `g:nv_search_paths`
* `g:nvlinks_notes_dir`

The first two are notational-fzf-vim settings.  Consult that plugin's
documentation for details.  In the event that you want to use this plugin by
itself, just define the third variable.  One of these will tell nvlinks where to
link to in order to either open or create links.

The link format is nvALT (and vimwiki) style: `[[link text]]`.  I didn't add
support for descriptions (of the style `[[link text|link desc]])` because I
didn't need it, but if this plugin somehow becomes somewhat popular and folks
request it, I guess it would be easy enough to add.

There is a single command defined, `:NVLinkHandleLink`, that will open the link
where the cursor is.  It is simple to bind this:  

```
nnoremap <C-CR> :NVLinkHandleLink<CR>
```

There are a few other features (some integration with notational-fzf-vim and
such), but the documentation is not finished.  For that matter, the plugin
itself is still under mild construction, so use at your own peril.  That said,
the basic functionality of highlighting and following links is there, so...

## Potential Issues

* Haven't tested on Windows (though in theory this should work quite well with
  WSL).
* There may not be enough error handling

## License

MIT
