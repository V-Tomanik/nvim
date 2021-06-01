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
vim.cmd('set termguicolors')
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
vim.cmd('colorscheme dracula')

--Para treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'python','lua'},
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
--Para file explorer
vim.g.nvim_tree_ignore ={'.git'}

--Para completion and ultisnipts
--vim.g.completion_enable_snippet='UltiSnips'

--Para dashboard
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_header={
    '',
    '   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ',
   	'    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
    '          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ',
    '           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
    '          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
    '   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
    '  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
    ' ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
    ' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ',
    '      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
    '       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
    '     ⢰⣶  ⣶ ⢶⣆⢀⣶⠂⣶⡶⠶⣦⡄⢰⣶⠶⢶⣦  ⣴⣶     ',
    '     ⢸⣿⠶⠶⣿ ⠈⢻⣿⠁ ⣿⡇ ⢸⣿⢸⣿⢶⣾⠏ ⣸⣟⣹⣧    ',
    '     ⠸⠿  ⠿  ⠸⠿  ⠿⠷⠶⠿⠃⠸⠿⠄⠙⠷⠤⠿⠉⠉⠿⠆   ',
    '',
    }

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

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
