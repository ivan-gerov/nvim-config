vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require('lazy').setup({ { import = 'plugins' }, { import = 'plugins.lsp' } }, {
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = { 'catppuccin' },
  },
  checker = { -- automatically check for plugin updates
    enabled = true,
    notify = false, -- get a notification when new updates are found
    frequency = 3600, -- check for updates every hour
    check_pinned = false, -- check for pinned packages that can't be updated
  },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        'gzip',
        -- "matchit",
        -- "matchparen",
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

vim.g.vscode_snippets_path = '~/.config/nvim/snippets'
vim.cmd 'colorscheme catppuccin-mocha'
vim.cmd 'hi LineNr guifg=#777777'
vim.cmd [[hi TreesitterContextBottom guisp=Grey]]
-- vim: ts=2 sts=2 sw=2 et
