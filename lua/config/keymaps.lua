-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Moving things around
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Python command flattener
vim.keymap.set('n', 'J', 'mzJ`z')

-- Center when moving rapidly around the page
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Center when searching for stuff
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Moving inside insert mode
vim.api.nvim_set_keymap('i', '<M-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<M-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<M-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<M-l>', '<Right>', { noremap = true, silent = true })

-- Better resizing keymaps
vim.keymap.set('n', '=', [[<cmd>vertical resize -5<cr>]], { desc = 'make the window smaller vertically' })
vim.keymap.set('n', '-', [[<cmd>vertical resize +5<cr>]], { desc = 'make the window biger vertically' })
vim.keymap.set('n', '+', [[<cmd>horizontal resize +2<cr>]], { desc = 'make the window bigger horizontally by pressing shift and =' })
vim.keymap.set('n', '_', [[<cmd>horizontal resize -2<cr>]], { desc = 'make the window smaller horizontally by pressing shift and -' })

-- Capitalizing the first character of words
vim.api.nvim_set_keymap(
  'v',
  'gs',
  ':s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g<CR>',
  { noremap = true, silent = true, desc = 'Capitalize the first character of the words in the selection' }
)

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
vim.api.nvim_set_keymap('n', '<leader>ps', [[<cmd>lua require("persistence").load()<cr>]], { desc = 'Load last session from this folder' })

-- restore the last session
vim.api.nvim_set_keymap('n', '<leader>pl', [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = 'Load last Session' })

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap('n', '<leader>pd', [[<cmd>lua require("persistence").stop()<cr>]], { desc = 'Stop persistence for this session' })
