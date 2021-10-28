local cmp = require "cmp"

local lspkind = require "lspkind"
lspkind.init()


vim.opt.completeopt = {"menu","menuone","noselect"}

cmp.setup{
--Locais para buscar o completion
sources = {
 {name="nvim_lsp"},
 {name="path"},
 {name="luasnip"},
 {name="buffer"}
},

 mapping = {
	['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
--Snippets
 snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  formatting = {
    -- Youtube: How to set up nice formatting for your sources.
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        path = "[path]",
        luasnip = "[snip]",
      },
    },
  }
}
