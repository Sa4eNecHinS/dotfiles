return {
  -- 1. Устанавливаем плагин темы
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Загружаем тему самой первой
    config = function()
      require("onedark").setup({
        style = "dark", -- Тот самый стиль со скрина
        transparent = false, -- Если хочешь прозрачный фон (опционально)
      })
      require("onedark").load()
    end,
  },

  -- 2. Настраиваем LazyVim, чтобы он использовал именно эту тему
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
