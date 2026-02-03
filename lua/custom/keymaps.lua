vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { buffer = true, desc = 'Move to left window from Terminal' })
    vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { buffer = true, desc = 'Move to right window from Terminal' })
    vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { buffer = true, desc = 'Move to lower window from Terminal' })
    vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { buffer = true, desc = 'Move to upper window from Terminal' })
  end,
})

local terminal_bufnr = nil
local terminal_winnr = nil

local function toggle_terminal()
  if terminal_winnr and vim.api.nvim_win_is_valid(terminal_winnr) then
    vim.api.nvim_win_close(terminal_winnr, false)
    terminal_winnr = nil
  else
    vim.cmd 'split'
    if terminal_bufnr and vim.api.nvim_buf_is_valid(terminal_bufnr) then
      vim.api.nvim_win_set_buf(0, terminal_bufnr)
    else
      vim.cmd 'terminal'
      terminal_bufnr = vim.api.nvim_get_current_buf()
    end
    terminal_winnr = vim.api.nvim_get_current_win()
    vim.cmd 'startinsert'
  end
end

vim.keymap.set('n', '<C-/>', toggle_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-/>', toggle_terminal, { desc = 'Toggle terminal' })

vim.keymap.set('n', '<leader>so', function() require('telescope.builtin').oldfiles { cwd_only = true } end, { desc = '[S]earch [O]ldfiles (cwd only)' })
