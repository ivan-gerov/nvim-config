-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Quickfix list
function ToggleQuickfix()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    if buftype == 'quickfix' then
      vim.cmd 'cclose'
      return
    end
  end
  vim.cmd 'copen'
end
vim.keymap.set('n', '<leader>q', [[:lua ToggleQuickfix()<CR>]], { silent = true, desc = 'Open quickfix list' })

-- Symbols Outline
vim.keymap.set('n', '<leader>so', '<cmd> :SymbolsOutline<CR>', { desc = 'Open Symbols Outline' })

-- Persistence
-- restore the session for the current directory
vim.api.nvim_set_keymap('n', '<leader>ps', [[<cmd>lua require("persistence").load()<cr>]], {})

-- restore the last session
vim.api.nvim_set_keymap('n', '<leader>pl', [[<cmd>lua require("persistence").load({ last = true })<cr>]], {})

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap('n', '<leader>pd', [[<cmd>lua require("persistence").stop()<cr>]], {})
