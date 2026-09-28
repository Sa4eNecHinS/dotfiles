-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader><space>", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })

local work = require("config.work")

-- ─────────────────────────────────────────────
-- Window navigation
-- ─────────────────────────────────────────────

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- ─────────────────────────────────────────────
-- Window resize
-- ─────────────────────────────────────────────

vim.keymap.set("n", "<C-->", "<cmd>resize -2<cr>", {
  desc = "Decrease Window Height",
})

vim.keymap.set("n", "<C-=>", "<cmd>resize +2<cr>", {
  desc = "Increase Window Height",
})

vim.keymap.set("n", "<C-,>", "<cmd>vertical resize -2<cr>", {
  desc = "Decrease Window Width",
})

vim.keymap.set("n", "<C-.>", "<cmd>vertical resize +2<cr>", {
  desc = "Increase Window Width",
})

local work_terminal = {
  buf = nil,
  win = nil,
}

local function find_editor_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)

    local filetype = vim.bo[buf].filetype
    local buftype = vim.bo[buf].buftype

    if filetype ~= "neo-tree" and buftype == "" then
      return win
    end
  end

  return nil
end

local function toggle_work_terminal()
  -- Terminal visible -> hide it
  if work_terminal.win and vim.api.nvim_win_is_valid(work_terminal.win) then
    vim.api.nvim_win_close(work_terminal.win, false)
    work_terminal.win = nil
    return
  end

  -- Find actual editor window instead of splitting Neo-tree
  local editor_win = find_editor_window()

  if not editor_win then
    vim.notify("No editor window found", vim.log.levels.WARN)
    return
  end

  -- Focus editor
  vim.api.nvim_set_current_win(editor_win)

  -- Split editor vertically and put terminal on the right
  vim.cmd("belowright vsplit")

  work_terminal.win = vim.api.nvim_get_current_win()

  -- Terminal width
  vim.cmd("vertical resize 55")

  -- Reuse existing terminal buffer
  if work_terminal.buf and vim.api.nvim_buf_is_valid(work_terminal.buf) then
    vim.api.nvim_win_set_buf(work_terminal.win, work_terminal.buf)
  else
    vim.cmd("terminal")
    work_terminal.buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<leader>\\", function()
  if vim.fn.mode() == "t" then
    vim.cmd("stopinsert")
  end

  toggle_work_terminal()
end, {
  desc = "Toggle Work Terminal",
})
