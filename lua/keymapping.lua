local map = vim.api.nvim_set_keymap

--================================
--			VIM  MAP
--================================

map('n','<Leader>q',':q<CR>',{})
map('n','<Leader>s',':w<CR>',{})
map('n','<Leader>vs',':sv<CR>',{})

map('i','<CapsLock>','<Esc>',{})
-- Movimentação de janelas
map('n','<Leader>l',':wincmd l<CR>',{})
map('n','<Leader>h',':wincmd h<CR>',{})
map('n','<Leader>k',':wincmd k<CR>',{})
map('n','<Leader>j',':wincmd j<CR>',{})

-- Movimentação de buffer
vim.api.nvim_set_keymap('n', '<TAB>', ':BufferNext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious<CR>', { noremap = true, silent = true })

-- Movimentação no terminal buffer
vim.cmd('tnoremap <Esc> <C-\\><C-n>')



--vim.api.nvim_set_keymap('t','<Alt>e','<Ctrl-l><Ctrl-N>',{})
vim.api.nvim_set_keymap('x','<expr><TAB>','pumvisible() ? "\\<C-n>" : "\\<TAB>"',{})

vim.cmd('inoremap <expr> <Tab>   pumvisible() ? "\\<C-n>" : "\\<Tab>"')
vim.cmd('inoremap <expr> <S-Tab> pumvisible() ? "\\<C-p>" : "\\<S-Tab>"')
--================================
--			TOOL'S  MAP
--================================

--================================
--			PLUGIN MAP
--================================
--Terminal
vim.cmd('nnoremap <silent> <C-z> :ToggleTerminal<Enter>')
vim.cmd('tnoremap <silent> <C-z> <C-\\><C-n>:ToggleTerminal<Enter>')

--NvimTree
vim.api.nvim_set_keymap('n','<Leader>pp',':NvimTreeToggle<CR>',{})

--Ultisnits
--vim.cmd('let g:completion_confirm_key = "\\<C-y>"')

-- Undotree
vim.api.nvim_set_keymap('n','<Leader>ut',':UndotreeToggle<CR>',{})

-- Telescope
vim.api.nvim_set_keymap('n','<Leader>sff',':Telescope git_files<CR>',{})
vim.api.nvim_set_keymap('n','<Leader>bf',':Telescope file_browser<CR>',{})
vim.api.nvim_set_keymap('n','<Leader>sf',':Telescope find_files<CR>',{})
-- LSP
vim.api.nvim_set_keymap('n','<silent>gd','vim.lsp.buf.definition()<CR>',{})
vim.api.nvim_set_keymap('n','<silent>gr','vim.lsp.buf.references()<CR>',{})

vim.api.nvim_set_keymap('n','<Leader>git',':Git<CR>',{})

