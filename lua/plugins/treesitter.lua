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
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false,
          filetypes = { 'html', 'javascript', 'typescript', 'markdown', 'javascriptreact', 'typescriptreact', 'xml' },
        },
      }
    end,
    lazy = true,
    event = 'VeryLazy',
  },
}
