-- File: ~/.config/nvim/lua/custom/error_jump.lua

local M = {}

function M.jump_to_error_location()
  -- Save the current position
  local start_line = vim.fn.line('.')
  local start_col = vim.fn.col('.')

  -- Search for the next line starting with "error["
  local error_line = vim.fn.search('^error\\[', 'nW')
  -- local line_number = vim.fn.search('^error\[.*', 'bW')

  
  if error_line == 0 then
    print("No error line found")
    return
  end

  -- Move to the next line
  vim.cmd('normal! j')

  -- Search for the file path
  local file_path = vim.fn.matchstr(vim.fn.getline('.'), 'src/.*\\.rs:\\d\\+:\\d\\+')
  
  if file_path == '' then
    print("No file path found")
    vim.fn.cursor(start_line, start_col)
    return
  end

  -- Extract the file path and line number
  local parts = vim.split(file_path, ':')
  local file = parts[1]
  local line = tonumber(parts[2])
  local col = tonumber(parts[3])

  -- Open the file
  vim.cmd('edit ' .. file)

  -- Move to the specified line and column
  vim.fn.cursor(line, col)
end

function M.setup()
  -- Create a user command
  vim.api.nvim_create_user_command('JumpToErrorLocation', M.jump_to_error_location, {})

  -- Optional: Create a mapping
  vim.api.nvim_set_keymap('n', '<leader>je', ':JumpToErrorLocation<CR>', { noremap = true, silent = true })
end
return M



