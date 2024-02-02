return {

  { 'digitaltoad/vim-pug' },
  {
    'dstein64/nvim-scrollview',
    event = 'VeryLazy',
    config = function()
      local scrollview = require 'scrollview'
      local scrollview_gitsigns = require 'scrollview.contrib.gitsigns'

      scrollview.setup {
        winblend = 50,
        signs_on_startup = {
          'conflicts',
          -- "cursor",
          'diagnostics',
          'folds',
          'loclist',
          'marks',
          'quickfix',
          'search',
          'spell',
          -- "textwidth",
          -- "trail",
        },
      }

      scrollview_gitsigns.setup {
        add_priority = 100,
        change_priority = 100,
        delete_priority = 100,
      }

      vim.api.nvim_set_hl(0, 'ScrollViewHover', { link = 'Search' })
    end,
  },
  {
    'ixru/nvim-markdown',
    config = function()
      vim.cmd 'map <Plug> <Plug>Markdown_Fold'
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = 'cd app && npm install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },
  {
    'glepnir/nerdicons.nvim',
    cmd = 'NerdIcons',
    config = function()
      require('nerdicons').setup {}
      vim.keymap.set({ 'n' }, '<leader>i', function()
        vim.cmd 'NerdIcons'
      end, { desc = 'Nerd [i]cons' })
    end,
  },
  -- Git related plugins
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set({ 'n' }, '<leader>G', '<cmd>Git | only<cr>', { silent = true, desc = 'fuGitive' })
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<Leader>gd', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diff File' },
      { '<Leader>gv', '<cmd>DiffviewOpen<CR>', desc = 'Diff View' },
    },
    opts = function()
      local actions = require 'diffview.actions'
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('rafi_diffview', {}),
        pattern = 'diffview:///panels/*',
        callback = function()
          vim.opt_local.cursorline = true
          vim.opt_local.winhighlight = 'CursorLine:WildMenu'
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { 'n', 'q', actions.close },
            { 'n', '<Tab>', actions.select_next_entry },
            { 'n', '<S-Tab>', actions.select_prev_entry },
            { 'n', '<LocalLeader>a', actions.focus_files },
            { 'n', '<LocalLeader>e', actions.toggle_files },
          },
          file_panel = {
            { 'n', 'q', actions.close },
            { 'n', 'h', actions.prev_entry },
            { 'n', 'o', actions.focus_entry },
            { 'n', 'gf', actions.goto_file },
            { 'n', 'sg', actions.goto_file_split },
            { 'n', 'st', actions.goto_file_tab },
            { 'n', '<C-r>', actions.refresh_files },
            { 'n', '<LocalLeader>e', actions.toggle_files },
          },
          file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>' },
            { 'n', 'o', actions.focus_entry },
            { 'n', 'O', actions.options },
          },
        },
      }
    end,
  },
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '│' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>gph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    priority = 999,
    dependencies = { 'folke/noice.nvim' },
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
      extensions = {
        'fugitive',
        'neo-tree',
        'quickfix',
        'toggleterm',
        'man',
        'nvim-dap-ui',
        'lazy',
        'fzf',
      },
    },
    config = function(_, opts)
      vim.opt.showmode = false
      opts.sections = {
        lualine_b = {
          'branch',
          'diff',
          { 'diagnostics', sources = { 'nvim_diagnostic' } },
          {
            require('noice').api.status.command.get,
            cond = require('noice').api.status.command.has,
            color = { fg = '#ff9e64' },
          },
          {
            require('noice').api.status.mode.get,
            cond = require('noice').api.status.mode.has,
            color = { fg = '#ff9e64' },
          },
        },
        lualine_c = { { 'filename', path = 1 } },
      }
      require('lualine').setup(opts)
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {
      indent = {
        char = '┊',
      },
      scope = {
        char = '┊',
        show_start = false,
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'declancm/maximize.nvim',
    opts = { default_keymaps = false },
    config = function(_, opts)
      require('maximize').setup(opts)
      vim.keymap.set('n', '<leader>o', function()
        require('maximize').toggle()
      end, { desc = 'make [O]nly window' })
    end,
  },
  { 'echasnovski/mini.ai', version = '*' },
}
