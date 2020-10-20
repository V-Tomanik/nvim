syntax on


set number
set relativenumber
set spell
syntax enable
set hidden 			"Ajuda a ter varios buffers
set nowrap    			"Mostra linhas longas ao inves de fold
set cursorcolumn 		"Mostra a coluna
set clipboard =unnamedplus 	"Copy and paste ao for
set noswapfile
set updatetime=50

call plug#begin('~/.config/nvim/autoload/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}		"DEUS
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }  	
Plug 'junegunn/fzf.vim'           			"Fzf pro vim
Plug 'itchyny/lightline.vim'        
Plug 'tpope/vim-fugitive'

"Plug 'metakirby5/codi.vim' 				"Live Code

call plug#end()



let mapleader = " "
colorscheme gruvbox 
set background=dark


let g:python3_host_prog = $HOME.'/.pyenv/versions/nvim/bin/python3'

"======= MAPEAMENTO DE TECLAS =========== 
nnoremap -c dd0
nnoremap <leader>q      :q <CR>
nnoremap <leader>l      :wincmd l<CR>
nnoremap <leader>h      :wincmd h<CR>
nnoremap <leader>k      :wincmd k<CR>
nnoremap <leader>j      :wincmd j<CR>
inoremap €              <Esc>

inoremap <expr> <c-j> ("\<C-n>") 				  "Control + teclas para se movimentar no auto complete
inoremap <expr> <c-k> ("\<C-p>")
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"           "Tab se movimenta no auto complete

autocmd FileType matlab  nnoremap <leader>r     :w<CR>:!clear;octave %<CR>
nnoremap <leader>s      :w<CR>


nnoremap <leader>sv     :vs<CR>

"====== CUSTOMIZAÇÃO DE PLUGINS =======
"====== LightLine

let g:lightline = {
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
	\ },
	\ 'component_function': {
	\   'gitbranch': 'FugitiveHead'
	\ },
	\ }



"====== Fugitive
nnoremap <leader>gs      :G<CR>

"====== UndoTree
nnoremap <leader>u      :UndotreeShow<CR>

"======NerdTree
nnoremap <leader>p	:NERDTreeToggleVCS<CR>

"=======	COC	
autocmd FileType python nnoremap <leader>r	:CocCommand python.execInTerminal

nnoremap <leader>td 	:CocCommand todolist.create
nnoremap <leader>tdl    :CocList todolist

"GoTo
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)



"====== Fzf
nnoremap <leader>sf     :GitFiles<CR>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_branch_actions = {
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}


"======         CODI   ===============
"highlight CodiVirtualText guifg=cyan
"let g:codi#virtual_text_prefix = "❯ "

"jnoremap <leader>cdi	:Codi
"nnoremap <leader>cdif	:Codi!




