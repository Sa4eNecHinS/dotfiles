return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true, -- Вот эта магия делает фон прозрачным
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}
