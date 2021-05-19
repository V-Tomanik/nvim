--Configurações gerais e keymaps

USER = vim.fn.expand("$USER")
local g = vim.g
local bo = vim.bo
local wo = vim.wo
local map = vim.api.nvim_set_keymap
--================================
--			VIM SETUP
--================================

-- Variaveis aplicadas globalmente

g.mapleader=' '
vim.cmd('set guicursor=')
g.hlsearch=true
g.hidden=true
g.clipboard="unnamedplus"
g.backup=false
g.undodir="~.vim/undodir"
g.updatetime=50
vim.cmd('set scrolloff=8')

-- Variaveis aplicadas ao buffer

vim.cmd('set ts=4')
vim.cmd('set sw=4')
bo.swapfile=false

-- Variaveis aplicadas na window

wo.number=true
wo.relativenumber=true
wo.wrap=false
wo.cursorcolumn=true
wo.signcolumn="yes"

vim.o.showtabline=2

vim.cmd('set completeopt=menuone,noinsert,noselect')
vim.cmd('set shortmess+=c')
--================================
--			PLUGIN SETUP
--================================

vim.cmd('colorscheme gruvbox')

--================================
--			LSP SETUP
--================================
--Python
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

--Lua
local sumneko_root_path="/home/" .. USER .. "/.config/nvim/lsp/lua-language-server"
local sumneko_binary="/home/" .. USER .. "/.config/nvim/lsp/lua-language-server/bin/Linux/lua-language-server"
require'lspconfig'.sumneko_lua.setup {
cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Setup your lua path
					path = vim.split(package.path, ';')
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {'vim'}
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
				}
			}
		}
}