-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Moving things around
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Diff current opened windows
vim.keymap.set('n', '<leader>dD', ':windo diffthis <cr>')
vim.keymap.set('n', '<leader>dQ', ':windo diffoff <cr>')

-- Clear highlighting on escape in normal mode
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>', { silent = true, desc = 'Clear search highlighting' })

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

vim.keymap.set('n', 'yc', 'yygccp', { remap = true, silent = true, desc = 'Copy the current line above and comment out this one' })

-- Capitalizing the first character of words
vim.api.nvim_set_keymap(
  'v',
  'gs',
  ':s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g<CR>',
  { noremap = true, silent = true, desc = 'Capitalize the first character of the words in the selection' }
)

-- Current buffer filepath
vim.keymap.set('n', '<leader>cf', function()
  vim.api.nvim_call_function('setreg', { '+', vim.fn.expand '%:.' })
end, { desc = 'Copy current file relpath' })
vim.keymap.set('n', '<leader>cF', function()
  vim.api.nvim_call_function('setreg', { '+', vim.fn.expand '%:p' })
end, { desc = 'Copy current file full path' })

-- Copy Django test to clipboard
vim.keymap.set('n', '<leader>ct', function()
  local filepath = vim.fn.expand '%:.' -- Get the relative file path
  local module_path = filepath:gsub('/', '.'):gsub('%.py$', '') -- Replace '/' with '.' and remove '.py'

  -- Function to find the class and method name
  local function get_class_and_method()
    local class_name, method_name
    local current_line = vim.fn.line '.'
    for i = current_line, 1, -1 do
      local line = vim.fn.getline(i)
      if not method_name and line:match '^%s*def%s+([%w_]+)' then
        method_name = line:match '^%s*def%s+([%w_]+)'
      end
      if not class_name and line:match '^%s*class%s+([%w_]+)' then
        class_name = line:match '^%s*class%s+([%w_]+)'
        break
      end
    end
    return class_name, method_name
  end

  local class_name, method_name = get_class_and_method()
  local full_path = module_path
  if class_name then
    full_path = full_path .. '.' .. class_name
  end
  if method_name then
    full_path = full_path .. '.' .. method_name
  end

  vim.api.nvim_call_function('setreg', { '+', full_path }) -- Copy to clipboard
end, { desc = 'Copy current Django test file path in package.module.Class.method format' })

-- Copy Pytest test to clipboard (using filepath)
vim.keymap.set('n', '<leader>cp', function()
  local filepath = vim.fn.expand '%:.' -- Get the relative file path

  -- Function to find the class and method name (reused from Django version)
  local function get_class_and_method()
    local class_name, method_name
    local current_line = vim.fn.line '.'
    for i = current_line, 1, -1 do
      local line = vim.fn.getline(i)
      if not method_name and line:match '^%s*def%s+([%w_]+)' then
        method_name = line:match '^%s*def%s+([%w_]+)'
      end
      if not class_name and line:match '^%s*class%s+([%w_]+)' then
        class_name = line:match '^%s*class%s+([%w_]+)'
        break
      end
    end
    return class_name, method_name
  end

  local class_name, method_name = get_class_and_method()

  local pytest_path = 'python -m pytest ' .. filepath -- Using filepath here
  if class_name then
    pytest_path = pytest_path .. '::' .. class_name
  end
  if method_name then
    pytest_path = pytest_path .. '::' .. method_name
  end

  vim.api.nvim_call_function('setreg', { '+', pytest_path }) -- Copy to clipboard
end, { desc = 'Copy current Pytest test path into clipboard' })

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

-- Persistence
-- restore the session for the current directory
vim.api.nvim_set_keymap('n', '<leader>ps', [[<cmd>lua require("persistence").load()<cr>]], { desc = 'Load last session from this folder' })

-- restore the last session
vim.api.nvim_set_keymap('n', '<leader>pl', [[<cmd>lua require("persistence").load({ last = true })<cr>]], { desc = 'Load last Session' })

-- stop Persistence => session won't be saved on exit
vim.api.nvim_set_keymap('n', '<leader>pd', [[<cmd>lua require("persistence").stop()<cr>]], { desc = 'Stop persistence for this session' })

-- Tabs
vim.keymap.set('n', '<leader>tn', '<cmd> :tabnew<CR>', { desc = 'Open a new tab' })
vim.keymap.set('n', '<leader>th', '<cmd> :tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<leader>tl', '<cmd> :tabnext<CR>', { desc = 'Go to next tab' })

-- Diagonstics Enable/Disable
vim.g['diagnostics_active'] = true
function Toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.disable()
    print 'Diagnostics disabled'
  else
    vim.g.diagnostics_active = true
    vim.diagnostic.enable()
    print 'Diagnostics enabled'
  end
end

vim.keymap.set('n', '<leader>xd', Toggle_diagnostics, { noremap = true, silent = true, desc = 'Toggle vim diagnostics' })
