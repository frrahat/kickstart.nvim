return {
  'kamrul1157024/nvim-pr',
  config = function()
    require('nvim-pr').setup()
    vim.keymap.set('n', '<leader>gpv', ':PR open<CR>', { desc = '[V]iew [P]R in the editor' })
    vim.keymap.set('n', '<leader>gpo', ':PR open_in_browser<CR>', { desc = '[O]pen [P]R in the browser' })
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
}
