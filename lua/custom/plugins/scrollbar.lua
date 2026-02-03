return {
  'petertriho/nvim-scrollbar',
  event = 'VeryLazy',
  config = function()
    require('scrollbar').setup {
      handlers = {
        gitsigns = true,
      },
    }
  end,
}
