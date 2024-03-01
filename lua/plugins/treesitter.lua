return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    config = function()
      -- From kickstart.nvim
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'bash',
            'lua',
            'norg',
            'python',
            'ron',
            'rust',
            'scala',
            'toml',
            'vimdoc',
            'vim',
            'tsx',
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<C-n>',
              node_incremental = '<C-n>',
              scope_incremental = '<C-s>',
              node_decremental = '<C-r>',
            },
          },
          autotag = {
            enable = true,
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = true,
            filetypes = { 'html', 'javascript', 'typescript', 'markdown', 'javascriptreact', 'typescriptreact', 'xml' },
          },
          textobjects = {
            lsp_interop = {
              enable = true,
              border = 'none',
              floating_preview_opts = {},
              peek_definition_code = {
                ['<leader>pf'] = '@function.outer',
                ['<leader>pF'] = '@class.outer',
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_previous_start = {
                ['<leader>tf'] = { query = '@function.outer', desc = 'Jump to start of method/function' },
                ['<leader>tc'] = { query = '@class.outer', desc = 'Jump to start of class' },
                ['<leader>tb'] = { query = '@block.outer', desc = 'Jump to start of block' },
              },
              goto_next_end = {
                ['<leader>tef'] = { query = '@function.outer', desc = 'Jump to start of method/function' },
                ['<leader>tec'] = { query = '@class.outer', desc = 'Jump to start of class' },
                ['<leader>teb'] = { query = '@block.outer', desc = 'Jump to start of block' },
              },
              goto_next_start = {
                ['<leader>tnf'] = { query = '@function.outer', desc = 'Jump to start of next method/function' },
                ['<leader>tnc'] = { query = '@class.outer', desc = 'Jump to start of next class' },
                ['<leader>tnb'] = { query = '@block.outer', desc = 'Jump to start of next block' },
              },
            },
          },
        }
      end, 0)
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup {
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = true,
        filetypes = { 'html', 'javascript', 'typescript', 'markdown', 'javascriptreact', 'typescriptreact', 'xml' },
      }
    end,
    lazy = true,
    event = 'VeryLazy',
  },
}
