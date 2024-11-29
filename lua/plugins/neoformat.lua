local function adjust_path_for_venv_and_neoformat()
  local venv_path = os.getenv 'VIRTUAL_ENV'
  local black_path
  if venv_path then
    -- Construct the path to black within the virtual environment
    local potential_black_path = venv_path .. '/bin/black' -- Adjust for Windows if necessary

    -- Check if black exists at the constructed path
    if vim.fn.filereadable(potential_black_path) == 1 then
      black_path = potential_black_path
      -- Prepend the virtual environment's bin to PATH to prioritize local packages
      local venv_bin = venv_path .. '/bin:' -- Adjust for Windows if necessary
      vim.env.PATH = venv_bin .. vim.env.PATH
    end
  end

  -- Configure Neoformat to use the determined black path, or default if not found
  vim.g.neoformat_python_black = {
    exe = black_path or 'black', -- Use the detected black path or default to 'black'
    args = { '--quiet', '-' },
    stdin = 1,
  }
end

return {
  'sbdchd/neoformat',
  config = function()
    local auto_format_enabled = true
    vim.api.nvim_create_user_command('AutoFormatEnable', function()
      auto_format_enabled = true
      print 'Auto format enabled.'
    end, {})
    vim.api.nvim_create_user_command('AutoFormatDisable', function()
      auto_format_enabled = false
      print 'Auto format disabled.'
    end, {})
    vim.api.nvim_create_user_command('AutoFormatToggle', function()
      if auto_format_enabled then
        vim.cmd 'AutoFormatDisable'
      else
        vim.cmd 'AutoFormatEnable'
      end
    end, {})

    local augroup = vim.api.nvim_create_augroup('fmt', { clear = true })
    local prettierd_filetypes = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.css', '*.scss', '*.html', '*.json' }
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      group = augroup,
      pattern = prettierd_filetypes,
      callback = function()
        vim.keymap.set({ 'n' }, '<leader>=', function()
          vim.cmd 'Neoformat prettierd'
        end, { desc = 'Neoformat', buffer = true })
      end,
    })
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = augroup,
      pattern = { '*.lua' },
      callback = function()
        if auto_format_enabled then
          vim.cmd 'Neoformat stylua'
        end
      end,
    })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      group = augroup,
      pattern = { '*.lua' },
      callback = function()
        vim.keymap.set({ 'n' }, '<leader>=', function()
          vim.cmd 'Neoformat stylua'
        end, { desc = 'Neoformat', buffer = true })
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      group = augroup,
      pattern = { '*.sql' },
      callback = function()
        local fileName = vim.fn.expand '%:p' -- Get full path of the current file
        local formatCommand = string.format('sql-formatter "%s" -l postgresql -o "%s"', fileName, fileName)

        local function formatSql()
          print('Formatting SQL file:', fileName)
          vim.fn.system(formatCommand)
          vim.cmd 'e!' -- Reload the buffer to reflect the changes
        end

        vim.keymap.set({ 'n' }, '<leader>=', formatSql, { desc = 'Neoformat', buffer = true })
      end,
    })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      group = augroup,
      pattern = { '*.java' },
      callback = function()
        vim.keymap.set({ 'n' }, '<leader>=', function()
          vim.cmd 'Neoformat googleformat'
        end, { desc = 'Neoformat', buffer = true })
      end,
    })

    adjust_path_for_venv_and_neoformat()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
      group = augroup,
      pattern = { '*.py' },
      callback = function()
        vim.keymap.set({ 'n' }, '<leader>=', function()
          vim.cmd 'Neoformat black'
        end, { desc = 'Neoformat', buffer = true })
      end,
    })
  end,
}
