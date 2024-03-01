-- local function live_grep_changed_files()
--   -- Define the custom command to list changed files
--   local list_changed_files_cmd = 'git diff --name-only --relative'
--
--   -- Temporarily override 'vimgrep_arguments' to use git command
--   local original_vimgrep_arguments = vim.deepcopy(require('telescope.config').values.vimgrep_arguments)
--   require('telescope.config').values.vimgrep_arguments = { 'git', 'grep', '-nH', '--no-color', '-e' }
--
--   -- Execute live_grep with an additional step to revert the change afterward
--   require('telescope.builtin').live_grep {
--     additional_args = function(opts)
--       return { list_changed_files_cmd }
--     end,
--     on_close = function()
--       -- Revert 'vimgrep_arguments' back to original after the search is complete
--       require('telescope.config').values.vimgrep_arguments = original_vimgrep_arguments
--     end,
--   }
-- end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = '^1.0.0',
    }, -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'axkirillov/telescope-changed-files' },
  },
  config = function()
    local actions = require 'telescope.actions'
    local lga_actions = require 'telescope-live-grep-args.actions'
    local opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          n = {
            ['<C-c>'] = require('telescope.actions').close,
            ['q'] = require('telescope.actions').close,
          },
        },
      },
      -- extensions = {
      --   live_grep_args = {
      --     auto_quoting = true,
      --     mappings = { -- extend mappings
      --       i = {
      --         ['<C-K>'] = lga_actions.quote_prompt(),
      --         ['<C-i>'] = lga_actions.quote_prompt { postfix = ' --iglob ' },
      --       },
      --     },
      --   },
      -- },
    }
    require('telescope').setup(opts)

    -- Enable telescope fzf native, if installed
    -- pcall(require('telescope').load_extension, 'fzf')
    -- pcall(require('telescope').load_extension, 'live_grep_args')
    -- pcall(require('telescope').load_extension, 'harpoon')
    -- pcall(require('telescope').load_extension, 'changed_files')

    local function live_grep_git_dir()
      local git_dir = vim.api.nvim_exec('!git rev-parse --show-toplevel', false)
      local opts = {
        cwd = git_dir,
      }
      require('telescope.builtin').live_grep(opts)
    end

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
    vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>gc', live_grep_git_dir, { desc = 'Search [G]it [F]iles' })
    vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep', silent = true })
    vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sc', require('telescope').extensions.changed_files.changed_files, { desc = '[S]earch [C]hanged files' })
    -- vim.keymap.set('n', '<leader>sC', live_grep_changed_files, { desc = '[S]earch in [C]hanged Files' })
  end,
}
