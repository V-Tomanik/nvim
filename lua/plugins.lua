do
	-- [[ Intro to `vim.pack` ]]
	-- `vim.pack` is a new plugin manager built into Neovim,
	--  which provides a Lua interface for installing and managing plugins.
	--
	--  See `:help vim.pack`, `:help vim.pack-examples` or the
	--  excellent blog post from the creator of vim.pack and mini.nvim:
	--  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
	--
	--  To inspect plugin state and pending updates, run
	--    :lua vim.pack.update(nil, { offline = true })
	--
	--  To update plugins, run
	--    :lua vim.pack.update()
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ''
			local stdout = result.stdout or ''
			local output = stderr ~= '' and stderr or stdout
			if output == '' then output = 'No output from build command.' end
			vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
		end
	end

	-- This autocommand runs after a plugin is installed or updated and
	--  runs the appropriate build command for that plugin if necessary.
	-- See `:help vim.pack-events`
	vim.api.nvim_create_autocmd('PackChanged', {
	    callback = function(ev)
	      local name = ev.data.spec.name
	      local kind = ev.data.kind
	      if kind ~= 'install' and kind ~= 'update' then return end

	      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
		run_build(name, { 'make' }, ev.data.path)
		return
	      end

	      if name == 'nvim-treesitter' then
		if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
		vim.cmd 'TSUpdate'
		return
	      end
	    end,
	  })

	---Because most plugins are hosted on GitHub, you can use the helper
	---function to have less repetition in the following sections.
	---@param repo string
	---@return string
	local function gh(repo) return 'https://github.com/' .. repo end

	-- INSTALL OF PLUGINS
	vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  	require('guess-indent').setup {}
	
	vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
	require('nvim-autopairs').setup {}

	vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
	local gitsigns = require 'gitsigns'
	gitsigns.setup {
		signs = {
			add = { text = '+' }, ---@diagnostic disable-line: missing-fields
			change = { text = '~' }, ---@diagnostic disable-line: missing-fields
			delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
			topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
			changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
		},
		-- Act on changes, not just see them: <leader>h = git [H]unk
		on_attach = function(bufnr)
			local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
			map('n', ']c', function()
				if vim.wo.diff then vim.cmd.normal { ']c', bang = true } else gitsigns.nav_hunk 'next' end
			end, 'Next git [c]hange')
			map('n', '[c', function()
				if vim.wo.diff then vim.cmd.normal { '[c', bang = true } else gitsigns.nav_hunk 'prev' end
			end, 'Previous git [c]hange')
			map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'git [s]tage hunk')
			map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'git [r]eset hunk')
			map('n', '<leader>hs', gitsigns.stage_hunk, 'git [s]tage hunk')
			map('n', '<leader>hr', gitsigns.reset_hunk, 'git [r]eset hunk')
			map('n', '<leader>hS', gitsigns.stage_buffer, 'git [S]tage buffer')
			map('n', '<leader>hR', gitsigns.reset_buffer, 'git [R]eset buffer')
			map('n', '<leader>hp', gitsigns.preview_hunk, 'git [p]review hunk')
			map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, 'git [b]lame line')
			map('n', '<leader>hd', gitsigns.diffthis, 'git [d]iff against index')
			map('n', '<leader>tb', gitsigns.toggle_current_line_blame, '[T]oggle git [b]lame line')
			map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'inside git hunk')
		end,
	}

	-- Lazygit in a floating terminal (needs `brew install lazygit`)
	vim.keymap.set('n', '<leader>gg', function()
		if vim.fn.executable 'lazygit' ~= 1 then
			vim.notify('lazygit not found: brew install lazygit', vim.log.levels.WARN)
			return
		end
		local buf = vim.api.nvim_create_buf(false, true)
		local w, h = math.floor(vim.o.columns * 0.9), math.floor(vim.o.lines * 0.9)
		local win = vim.api.nvim_open_win(buf, true, {
			relative = 'editor', width = w, height = h,
			col = math.floor((vim.o.columns - w) / 2), row = math.floor((vim.o.lines - h) / 2),
			style = 'minimal', border = 'rounded',
		})
		vim.fn.jobstart({ 'lazygit' }, {
			term = true,
			on_exit = function()
				if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
				if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
				vim.cmd 'checktime' -- reload files lazygit may have changed
			end,
		})
		vim.cmd.startinsert()
	end, { desc = '[G]it: lazy[g]it' })

	-- Shows pending keybinds after you press <leader>, g, etc.
	vim.pack.add { gh 'folke/which-key.nvim' }
	require('which-key').setup {
		delay = 300,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
			{ '<leader>t', group = '[T]oggle' },
			{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
			{ '<leader>g', group = '[G]it' },
			{ 'gr', group = 'LSP Actions' },
		},
	}

	-- Colorscheme: Catppuccin Mocha, same palette as the Ghostty and tmux configs in station/.
	-- Preview others live with :Telescope colorscheme
	vim.pack.add { { src = gh 'catppuccin/nvim', name = 'catppuccin' } }
	require('catppuccin').setup { flavour = 'mocha' }
	vim.cmd.colorscheme 'catppuccin'

	-- CTRL+<hjkl> moves between Neovim splits and tmux panes seamlessly.
	-- Outside tmux it simply moves between splits. Needs the matching block in station/tmux/tmux.conf.
	vim.pack.add { gh 'christoomey/vim-tmux-navigator' }

	-- File explorer: see lua/explorer.lua (mini.files, Space e)
	-- Highlight todo, notes, etc in comments
	vim.pack.add { gh 'folke/todo-comments.nvim' }
	require('todo-comments').setup { signs = false }
	
	--Lua Line
	vim.pack.add({
	    'https://github.com/nvim-tree/nvim-web-devicons',
	    'https://github.com/nvim-lualine/lualine.nvim'
	})

	require('lualine').setup()
	

	-- Telescope, search and navigation
	-- See `:help telescope` and `:help telescope.setup()`
	-- See :Telescope help tags
	---@type (string|vim.pack.Spec)[]
	local telescope_plugins = {
	    gh 'nvim-lua/plenary.nvim',
	    gh 'nvim-telescope/telescope.nvim',
	    gh 'nvim-telescope/telescope-ui-select.nvim',
	  }
	if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

	vim.pack.add(telescope_plugins)
	require('telescope').setup {
		-- You can put your default mappings / updates / etc. in here
		--  All the info you're looking for is in `:help telescope.setup()`
		--
		-- defaults = {
		--   mappings = {
		--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
		--   },
		-- },
		-- pickers = {}
		extensions = {
			['ui-select'] = { require('telescope.themes').get_dropdown() },
		},
		}
	-- Enable telescope extensions
	pcall(require('telescope').load_extension, 'fzf')
  	pcall(require('telescope').load_extension, 'ui-select')
	
	-- See `:help telescope.builtin`
	local builtin = require 'telescope.builtin'
	vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
	vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
	vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
	vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
	vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
	vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
	vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
	vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
	vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
	vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
	vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

	-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
	-- If you later switch picker plugins, this is where to update these mappings.
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
	  	callback = function(event)
	    	local buf = event.buf

	    	-- Find references for the word under your cursor.
	      	vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

	      	-- Jump to the implementation of the word under your cursor.
	      	-- Useful when your language has ways of declaring types without an actual implementation.
	      	vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

	      	-- Jump to the definition of the word under your cursor.
	      	-- This is where a variable was first declared, or where a function is defined, etc.
	      	-- To jump back, press <C-t>.
	      	vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

	      	-- Fuzzy find all the symbols in your current document.
	      	-- Symbols are things like variables, functions, types, etc.
	      	vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

	      	-- Fuzzy find all the symbols in your current workspace.
	      	-- Similar to document symbols, except searches over your entire project.
	      	vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

	      	-- Jump to the type of the word under your cursor.
	      	-- Useful when you're not sure what type a variable is and you want to see
	      	-- the definition of its *type*, not where it was *defined*.
	      	vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
	end,
	})

	-- Override default behavior and theme when searching
	vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
	    winblend = 10,
	    previewer = false,
	})
	end, { desc = '[/] Fuzzily search in current buffer' })

	-- It's also possible to pass additional configuration options.
	--  See `:help telescope.builtin.live_grep()` for information about particular keys
	vim.keymap.set(
	  'n',
	  '<leader>s/',
	  function()
	    builtin.live_grep {
		grep_open_files = true,
		prompt_title = 'Live Grep in Open Files',
	      }
	    end,
	    { desc = '[S]earch [/] in Open Files' }
	  )

	  -- Shortcut for searching your Neovim configuration files
	  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
end


