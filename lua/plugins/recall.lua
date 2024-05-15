return {
  'fnune/recall.nvim',
  version = '*',
  config = function()
    local recall = require 'recall'

    recall.setup {}

    vim.keymap.set('n', '<leader>mm', recall.toggle, { noremap = true, silent = true, desc = 'Recall: Toggle Mark' })
    vim.keymap.set('n', '<leader>mj', recall.goto_next, { noremap = true, silent = true, desc = 'Recall: Go to Next Mark' })
    vim.keymap.set('n', '<leader>mk', recall.goto_prev, { noremap = true, silent = true, desc = 'Recall: Go to Previous Mark' })
    vim.keymap.set('n', '<leader>mC', recall.clear, { noremap = true, silent = true, desc = 'Recall: Clear Marks' })
    vim.keymap.set('n', '<leader>ml', ':Telescope recall<CR>', { noremap = true, silent = true, desc = 'Recall: Telescope Recall' })
  end,
}
