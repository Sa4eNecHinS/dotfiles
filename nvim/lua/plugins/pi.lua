return {
  {
    "alex35mil/pi.nvim",

    opts = {
      layout = {
        default = "side",

        side = {
          position = "right",
          width = 80,
        },
      },

      cli = {
        bin = "pi",
        args = {},
      },
    },

    keys = {
      {
        "<leader>\\",
        function()
          if vim.fn.mode() == "i" then
            vim.cmd("stopinsert")
          end

          require("pi").toggle({
            layout = "side",
          })
        end,
        mode = { "n", "v" },
        desc = "Toggle Pi Agent",
      },
    },
  },
}
