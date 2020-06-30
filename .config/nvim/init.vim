"__     _____ __  __ ____   ____ 
"\ \   / /_ _|  \/  |  _ \ / ___|
" \ \ / / | || |\/| | |_) | |    
"  \ V /  | || |  | |  _ <| |___ 
"   \_/  |___|_|  |_|_| \_\\____|
"                                

set noshowmode
set number
set relativenumber
set path+=**
set nowrap

call plug#begin('~/.config/nvim/plugged')

	"Install nova-vim
	Plug 'joshdick/onedark.vim'
	
	"Install Gruvbox theme
	Plug 'morhetz/gruvbox'

	"Install Lightline
	Plug 'itchyny/lightline.vim'

	"Install Polyglot
	Plug 'sheerun/vim-polyglot'

	"Install Colorize
	Plug 'chrisbra/colorizer'
call plug#end()

let g:lightline = { 'colorscheme': 'onedark' }

syntax on
colorscheme gruvbox
