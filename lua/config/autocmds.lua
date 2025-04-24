-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Create an augroup to organize the autocmd
local tabonleft_group = vim.api.nvim_create_augroup('tabonleft', { clear = true })
-- Create an autocmd that triggers on the TabClosed event
vim.api.nvim_create_autocmd('TabClosed', {
  group = tabonleft_group,
  callback = function(event)
    local closed = tonumber(event.match)
    if closed and closed > 1 then
      local desired = closed - 1
      -- Make sure the desired tab number does not exceed the number of tabs.
      if desired <= vim.fn.tabpagenr '$' then
        -- Only switch if we’re not already in the desired tab.
        if vim.fn.tabpagenr() ~= desired then
          vim.cmd(desired .. 'tabnext')
        end
      end
    end
  end,
})
