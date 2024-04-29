return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    local harpoon_mark = require 'harpoon.mark'
    local harpoon_ui = require 'harpoon.ui'

    keymap.set('n', '<leader>hm', harpoon_mark.add_file, { desc = 'Mark file with harpoon' })
    keymap.set('n', '<leader>hd', function()
      local index = harpoon_mark.get_index_of(vim.fn.bufname())
      harpoon_mark.rm_file(index)
    end, { desc = 'Remove marked file from harpoon' })
    keymap.set('n', '<leader>hC', harpoon_mark.clear_all, { desc = 'Clear all marked files from harpoon' })
    keymap.set('n', '<leader>hj', harpoon_ui.nav_next, { desc = 'Go to next harpoon mark' })
    keymap.set('n', '<leader>hk', harpoon_ui.nav_prev, { desc = 'Go to previous harpoon mark' })
    keymap.set('n', '<leader>ho', harpoon_ui.toggle_quick_menu, { desc = 'Open the harpoon menu' })
  end,
}
