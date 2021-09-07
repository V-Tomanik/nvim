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
vim.api.nvim_set_keymap('n', 'bc', ':BufferClose<CR>', { noremap = true, silent = true })
-- Movimentação no terminal buffer
vim.cmd('tnoremap <Esc> <C-\\><C-n>')

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

-- Completion
--Tab seleciona o item no popup

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

--Fazer funcionar o completion do snippet
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap('n', "<silent><expr><Enter>", "vim.fn[compe#confirm()]",{expr = true})

