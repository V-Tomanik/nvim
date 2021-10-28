--Configurações gerais e keymaps

USER = vim.fn.expand("$USER")
local g = vim.g
local bo = vim.bo
local wo = vim.wo
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

vim.cmd('set shortmess+=c')
--================================
--			PLUGIN SETUP
--================================
vim.cmd('colorscheme dracula')

--Para treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'python','lua'},
  highlight = {
    enable = false,              -- false will disable the whole extension
  },
}
--Para file explorer
require'nvim-tree'.setup {
      disable_netrw       = true,
      hijack_netrw        = true,
      open_on_setup       = false,
      ignore_ft_on_setup  = {},
      update_to_buf_dir   = {
        enable = true,
        auto_open = true,
      },
      auto_close          = true,
      open_on_tab         = false,
      hijack_cursor       = false,
      update_cwd          = true,
      diagnostics         = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        }
      },
      update_focused_file = {
        enable      = true,
        update_cwd  = true,
        ignore_list = {}
      },
      system_open = {
        cmd  = nil,
        args = {}
      },
      view = {
        width = 30,
        height = 30,
        side = 'left',
        auto_resize = false,
        mappings = {
          custom_only = false,
          list = {}
        }
      }
    }


--Para dashboard
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_header={
    
         '',
         '   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠞⠉⢉⣭⣿⣿⠿⣳⣤⠴⠖⠛⣛⣿⣿⡷⠖⣶⣤⡀⠀⠀⠀   ',
         '    ⠀⠀⠀⠀⠀⠀⠀⣼⠁⢀⣶⢻⡟⠿⠋⣴⠿⢻⣧⡴⠟⠋⠿⠛⠠⠾⢛⣵⣿⠀⠀⠀⠀  ',
         '    ⣼⣿⡿⢶⣄⠀⢀⡇⢀⡿⠁⠈⠀⠀⣀⣉⣀⠘⣿⠀⠀⣀⣀⠀⠀⠀⠛⡹⠋⠀⠀⠀⠀  ',
         '    ⣭⣤⡈⢑⣼⣻⣿⣧⡌⠁⠀⢀⣴⠟⠋⠉⠉⠛⣿⣴⠟⠋⠙⠻⣦⡰⣞⠁⢀⣤⣦⣤⠀  ',
         '    ⠀⠀⣰⢫⣾⠋⣽⠟⠑⠛⢠⡟⠁⠀⠀⠀⠀⠀⠈⢻⡄⠀⠀⠀⠘⣷⡈⠻⣍⠤⢤⣌⣀  ',
         '    ⢀⡞⣡⡌⠁⠀⠀⠀⠀⢀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠀⠀⠀⠸⣇⠀⢾⣷⢤⣬⣉  ',
         '    ⡞⣼⣿⣤⣄⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⣿⠀⠸⣿⣇⠈⠻  ',
         '    ⢰⣿⡿⢹⠃⠀⣠⠤⠶⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⣿⠀⠀⣿⠛⡄⠀  ',
         '    ⠈⠉⠁⠀⠀⠀⡟⡀⠀⠈⡗⠲⠶⠦⢤⣤⣤⣄⣀⣀⣸⣧⣤⣤⠤⠤⣿⣀⡀⠉⣼⡇⠀  ',
         '    ⣿⣴⣴⡆⠀⠀⠻⣄⠀⠀⠡⠀⠀⠀⠈⠛⠋⠀⠀⠀⡈⠀⠻⠟⠀⢀⠋⠉⠙⢷⡿⡇⠀  ',
         '    ⣻⡿⠏⠁⠀⠀⢠⡟⠀⠀⠀⠣⡀⠀⠀⠀⠀⠀⢀⣄⠀⠀⠀⠀⢀⠈⠀⢀⣀⡾⣴⠃⠀  ',
         '    ⢿⠛⠀⠀⠀⠀⢸⠁⠀⠀⠀⠀⠈⠢⠄⣀⠠⠼⣁⠀⡱⠤⠤⠐⠁⠀⠀⣸⠋⢻⡟⠀⠀  ',
         '    ⠈⢧⣀⣤⣶⡄⠘⣆⠀⠀⠀⠀⠀⠀⠀⢀⣤⠖⠛⠻⣄⠀⠀⠀⢀⣠⡾⠋⢀⡞⠀⠀⠀  ',
         '    ⠀⠀⠻⣿⣿⡇⠀⠈⠓⢦⣤⣤⣤⡤⠞⠉⠀⠀⠀⠀⠈⠛⠒⠚⢩⡅⣠⡴⠋⠀⠀⠀⠀  ',
         '    ⠀⠀⠀⠈⠻⢧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣻⠿⠋⠀⠀⠀⠀⠀⠀  ',
         '    ⠀⠀⠀⠀⠀⠀⠉⠓⠶⣤⣄⣀⡀⠀⠀⠀⠀⠀⢀⣀⣠⡴⠖⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀  ',
         '                                       ',
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

--Função para instalar os servers e setp (lspinstall e lspconfig)
local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}

	if server == 'lua' then
    	require'lspconfig'[server].setup{
		settings={Lua={diagnostics={globals={'vim'}}}}
		}
	elseif server == 'python' then
		require'lspconfig'[server].setup{
		settings={reportMissingTypeStubs={'None'},
		reportGeneralTypeIssues={'None'}
	}
		}
	else
    require'lspconfig'[server].setup{}
	end
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

