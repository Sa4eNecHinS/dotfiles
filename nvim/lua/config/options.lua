-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.relativenumber = false -- отключение относительных строк
vim.opt.number = true -- включение обычных строк
--vim.opt.shiftwidth = 4 -- Ширина отступа
--vim.opt.tabstop = 4 --  ширина символа табуляции
vim.opt.expandtab = true -- табы -> в пробелы
vim.opt.spelllang = { "en", "ru" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.b.autoformat = false
  end,
})
