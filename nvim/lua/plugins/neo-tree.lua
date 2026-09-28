return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    opts = {
      window = {
        position = "left",
        width = 30,

        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
        },
      },

      filesystem = {
        follow_current_file = {
          enabled = true,
        },

        use_libuv_file_watcher = true,
      },
    },
  },
}
