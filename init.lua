-- SECTION 1: INITIAL SETUP
do
	-- Enable faster startup by caching compiled Lua modules
  	vim.loader.enable()

	-- Set <space> as the leader key
  	-- See `:help mapleader`
  	--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  	vim.g.mapleader = ' '
  	vim.g.maplocalleader = ' '
	
  	-- Make line numbers default
  	vim.o.relativenumber = true
	-- Enable mouse mode, can be useful for resizing splits for example!
	vim.o.mouse='a'
	-- Don't show the mode, since it's already in the status line
  	vim.o.showmode = false
	-- Enable break indent
  	vim.o.breakindent = true
  
	-- copy and past clipboard between os and nvim
	vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  	-- Enable undo/redo changes even after closing and reopening a file
  	vim.o.undofile = true

  	-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  	vim.o.ignorecase = true
  	vim.o.smartcase = true

  	-- Keep signcolumn on by default
  	vim.o.signcolumn = 'yes'

  	-- Decrease update time
  	vim.o.updatetime = 250

  	-- Decrease mapped sequence wait time
  	vim.o.timeoutlen = 300

  	-- Configure how new splits should be opened
  	vim.o.splitright = true
  	vim.o.splitbelow = true
	-- Preview substitutions live, as you type!
  	vim.o.inccommand = 'split'

  	-- Show which line your cursor is on
  	vim.o.cursorline = true

  	-- Minimal number of screen lines to keep above and below the cursor.
  	vim.o.scrolloff = 10

  	-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  	-- instead raise a dialog asking if you wish to save the current file(s)
  	vim.o.confirm = true


	-- Diagnostic Config & Keymaps
  	--  See `:help vim.diagnostic.Opts`
  	vim.diagnostic.config {
    	update_in_insert = false,
    	severity_sort = true,
    	float = { border = 'rounded', source = 'if_many' },
    	underline = { severity = { min = vim.diagnostic.severity.WARN } },

    	-- Can switch between these as you prefer
    	virtual_text = true, -- Text shows up at the end of the line
    	virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    	jump = {
      	on_jump = function(_, bufnr)
        	vim.diagnostic.open_float {
          	bufnr = bufnr,
          	scope = 'cursor',
          	focus = false,
        	}
     	 end,
    	},
  	}
 	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  	-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  	-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  	-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  	vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  	vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  	vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  	vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  	-- Keybinds to make split navigation easier.
  	--  Use CTRL+<hjkl> to switch between windows
  	--  See `:help wincmd` for a list of all window commands
	vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  	vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  	vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  	vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


 	-- Highlight when yanking (copying) text
  	--  See `:help vim.hl.on_yank()`
  	vim.api.nvim_create_autocmd('TextYankPost', {
    	 	desc = 'Highlight when yanking (copying) text',
    	 	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    		callback = function() vim.hl.on_yank() end,
		})
	end

do
-- SECTION 2: PLUGIN MANAGER
require("plugins")
require("lsp")
require("treesitter")
end

