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
      vim.keymap.set({ 'n' }, '<leader>gb', '<cmd>Git blame<cr>', { silent = true, desc = 'Git blame' })
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
        vim.keymap.set('n', '<leader>gj', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>gk', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk_inline, { buffer = bufnr, desc = '[P]review [H]unk' })
        vim.keymap.set('n', '<leader>gu', require('gitsigns').reset_hunk, { buffer = bufnr, desc = 'Undo [H]unk' })
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
  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
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
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = '-',
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (
    },
  },
  { 'kyazdani42/nvim-web-devicons' },
  {
    'keaising/im-select.nvim',
    config = function()
      require('im_select').setup {
        -- IM will be set to `default_im_select` in `normal` mode
        -- For Windows/WSL, default: "1033", aka: English US Keyboard
        -- For macOS, default: "com.apple.keylayout.ABC", aka: US
        -- For Linux, default:
        --               "keyboard-us" for Fcitx5
        --               "1" for Fcitx
        --               "xkb:us::eng" for ibus
        -- You can use `im-select` or `fcitx5-remote -n` to get the IM's name
        default_im_select = 'com.apple.keylayout.ABC',

        -- Can be binary's name or binary's full path,
        -- e.g. 'im-select' or '/usr/local/bin/im-select'
        -- For Windows/WSL, default: "im-select.exe"
        -- For macOS, default: "im-select"
        -- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
        default_command = 'im-select',

        -- Restore the default input method state when the following events are triggered
        set_default_events = { 'VimEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave' },

        -- Restore the previous used input method state when the following events
        -- are triggered, if you don't want to restore previous used im in Insert mode,
        -- e.g. deprecated `disable_auto_restore = 1`, just let it empty
        -- as `set_previous_events = {}`
        set_previous_events = { 'InsertEnter' },

        -- Show notification about how to install executable binary when binary missed
        keep_quiet_on_no_binary = false,

        -- Async run `default_command` to switch IM or not
        async_switch_im = true,
      }
    end,
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'ellisonleao/carbon-now.nvim',
    lazy = true,
    cmd = 'CarbonNow',
    opts = {},
    config = function()
      require('carbon-now').setup { open_cmd = 'open' }
    end,
  },
  {
    'rmagatti/goto-preview',
    config = function()
      local goto_preview = require 'goto-preview'
      local keymap = vim.keymap

      goto_preview.setup {
        width = 120, -- Width of the floating window
        height = 20, -- Height of the floating window
        border = { '↖', '─', '┐', '│', '┘', '─', '└', '│' }, -- Border characters of the floating window
        default_mappings = false, -- UnBind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
          telescope = require('telescope.themes').get_dropdown { hide_preview = false },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = 'wipe', -- the bufhidden option to set on the floating window. See :h bufhidden
        stack_floating_preview_windows = false, -- Whether to nest floating windows
        preview_window_title = { enable = true, position = 'left' }, -- Whether to set the preview window title as the filename
      }

      keymap.set('n', 'gp', goto_preview.goto_preview_definition, { noremap = true })
      keymap.set('n', 'gP', goto_preview.close_all_win, { noremap = true })
    end,
  },

  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    version = '*',
    opts = {
      options = {
        mode = 'tabs',
        separator_style = 'slant',
        always_show_bufferline = false,
        show_duplicate_prefix = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
    },
  },
  {
    'tpope/vim-surround',
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },

  -- {
  --   'nvim-focus/focus.nvim',
  --   version = '*',
  --   config = function()
  --     require('focus').setup()
  --   end,
  -- },
}
