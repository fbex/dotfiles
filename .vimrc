" automatic vim-plug download
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" load plugins via vim-plug
call plug#begin()
Plug 'fladson/vim-kitty'
Plug 'morhetz/gruvbox'
call plug#end()

" set gruvbox theme
let g:gruvbox_italic=1
set termguicolors
set background=dark
autocmd vimenter * ++nested colorscheme gruvbox

" relative line numbers
set number
set relativenumber
" search settings
set ignorecase
set incsearch " show partial matches
set hlsearch " highlight matches

" enable fzf (fuzzyfind)
set rtp+=/opt/homebrew/opt/fzf

