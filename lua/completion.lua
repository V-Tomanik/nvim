-- AUTOCOMPLETE & SNIPPETS
-- blink.cmp with Neovim's built-in snippet engine (vim.snippet) + friendly-snippets
do
	local function gh(repo) return 'https://github.com/' .. repo end

	-- Premade snippets for Python, JS/TS, HTML, CSS, Lua, etc.
	vim.pack.add { gh 'rafamadriz/friendly-snippets' }

	-- Pinned to 1.x tags so blink can download its prebuilt fuzzy-matcher binary
	vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
	require('blink.cmp').setup {
		keymap = {
			-- 'default': <C-y> accepts, <C-n>/<C-p> move, <C-space> opens menu/docs,
			-- <C-e> hides, <C-k> toggles signature help, <Tab>/<S-Tab> jump in snippets.
			-- Switch to 'super-tab' or 'enter' if you prefer those to accept.
			preset = 'default',
		},
		appearance = { nerd_font_variant = 'mono' },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 300 },
		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
		-- Rust matcher: faster and typo-tolerant. Falls back to Lua (with a warning)
		-- if the prebuilt binary can't be downloaded.
		fuzzy = { implementation = 'prefer_rust_with_warning' },
		signature = { enabled = true },
	}
end
