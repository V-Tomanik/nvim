local map = vim.api.nvim_set_keymap
require 'tools'
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
map('n', '<TAB>', ':BufferNext<CR>', { noremap = true, silent = true })
map('n', '<S-TAB>', ':BufferPrevious<CR>', { noremap = true, silent = true })
map('n', 'bc', ':BufferClose<CR>', { noremap = true, silent = true })
-- Movimentação no terminal buffer
vim.cmd('tnoremap <Esc> <C-\\><C-n>')

--Criar file novo
map('n', '<Leader>nf<CR>',':newtab',{})
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
map('n','<Leader>pp',':NvimTreeToggle<CR>',{})

-- Undotree
map('n','<Leader>ut',':UndotreeToggle<CR>',{})

-- Telescope
map('n','<Leader>sff',':Telescope git_files<CR>',{})
map('n','<Leader>bf',':Telescope file_browser<CR>',{})
map('n','<Leader>sf',':Telescope find_files<CR>',{})
-- LSP
map('n','<silent>gd','vim.lsp.buf.definition()<CR>',{})
map('n','<silent>gr','vim.lsp.buf.references()<CR>',{})

map('n','<Leader>git',':Git<CR>',{})

-- Completion
--Tab seleciona o item no popup
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
