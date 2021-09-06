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
return require('packer').startup(function()
	use {'wbthomason/packer.nvim'}
	use {'neovim/nvim-lspconfig'}
	use {'gruvbox-community/gruvbox', as = 'gruvbox'}
  	use {'dracula/vim', as = 'dracula'}
	use {'tpope/vim-fugitive'}
	use {'kyazdani42/nvim-web-devicons'}
	use {'romgrk/barbar.nvim'}
	use {'mbbill/undotree'}
	use {'nvim-telescope/telescope.nvim',
			requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}
	use {
  		"ahmedkhalf/project.nvim",
  		config = function()
    		require("project_nvim").setup {
			require('telescope').load_extension('projects')}
		end}
	use {  "hrsh7th/nvim-cmp",
  		requires = {
    	"hrsh7th/vim-vsnip",
    	"hrsh7th/cmp-buffer",}}
	use {'nvim-treesitter/nvim-treesitter'}
	use {'glepnir/dashboard-nvim'}
	use {'saadparwaiz1/cmp_luasnip'}
  	use {'L3MON4D3/LuaSnip'} -- Snippets plugin
	use {'hoob3rt/lualine.nvim',
  		requires = {'kyazdani42/nvim-web-devicons', opt = true}}
	use {'caenrique/nvim-toggle-terminal'}
	use {'kyazdani42/nvim-tree.lua',
  		requires = {'kyazdani42/nvim-web-devicons', opt = true}}
	use {'kabouzeid/nvim-lspinstall'}
end)





