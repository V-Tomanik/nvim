--Instalação de plugins
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
--Installa o packer se não tiver sido instalado
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

--Instala os plugins (quando esse arquivo é chamdo retorna essa função aqui)
return require('packer').startup(function(use)
	use {'wbthomason/packer.nvim'}

	--Temas
	use {'gruvbox-community/gruvbox', as = 'gruvbox'}
  	use {'dracula/vim', as = 'dracula'}
	use {'kyazdani42/nvim-web-devicons'}

	-- Git
	use {'tpope/vim-fugitive'}

	-- Barras de Buffers
	use {'romgrk/barbar.nvim'}
	use {'mbbill/undotree'}

	-- Plugins Telescopes
	use {'nvim-telescope/telescope.nvim',
			requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
	use {"ahmedkhalf/project.nvim",
  		config = function()
    		require("project_nvim").setup {
			require('telescope').load_extension('projects')}
		end}

	use {'nvim-treesitter/nvim-treesitter'}

	--StartUp Dash
	use {'glepnir/dashboard-nvim'}

	use {'hoob3rt/lualine.nvim',
  		requires = {'kyazdani42/nvim-web-devicons', opt = true}}

	--Terminal Switch
	use {'caenrique/nvim-toggle-terminal'}
	use {'kyazdani42/nvim-tree.lua',
  		requires = {'kyazdani42/nvim-web-devicons', opt = true}}

	use{'L3MON4D3/LuaSnip'} --Snippets
	use{'rafamadriz/friendly-snippets'}

	--LSP Stuff
	use {'kabouzeid/nvim-lspinstall'}
	use {'neovim/nvim-lspconfig'}
	use{'onsails/lspkind-nvim'}
	--Completion
	use {'hrsh7th/nvim-cmp'}
	use {'hrsh7th/cmp-buffer'} -- Completion via buffer
	use {'hrsh7th/cmp-path'} -- Completion of files
	use {'hrsh7th/cmp-nvim-lsp'} -- Completion via lsp
	use {'saadparwaiz1/cmp_luasnip'} --Completion via luasnip

	use {'chipsenkbeil/distant.nvim', --Trabalhar com SSH
  		config = function()
    	require('distant').setup {
      		-- Applies Chip's personal settings to every machine you connect to
      		-- 1. Ensures that distant servers terminate with no connections
      		-- 2. Provides navigation bindings for remote directories
      		-- 3. Provides keybinding to jump into a remote file's parent directory
      		['*'] = require('distant.settings').chip_default()
    		}end}

end)





