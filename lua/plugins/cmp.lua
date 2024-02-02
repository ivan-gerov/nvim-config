return {
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Sourde for text in buffer
      'hrsh7th/cmp-buffer',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },

    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = '~/.config/nvim/snippets' }
      luasnip.config.setup {}

      cmp.setup {
        completion = {
          completeout = 'menu,menuone,preview,noselect',
        },
        snippet = { --configure how nvim-cmp interacts with snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm(),
        },
        sources = cmp.config.sources {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },
}
