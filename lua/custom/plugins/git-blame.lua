return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  config = function()
    require('gitblame').setup {
      enabled = false,
      message_template = ' <author> • <date> • <summary>',
      date_format = '%r',
      virtual_text_column = 80,
    }

    vim.keymap.set('n', '<leader>tb', '<cmd>GitBlameToggle<cr>', { desc = '[T]oggle Git [B]lame' })
    vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameOpenCommitURL<cr>', { desc = '[G]it [B]lame Open Commit URL' })
  end,
}
