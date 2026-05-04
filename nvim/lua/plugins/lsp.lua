return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--fallback-style=webkit",
            "-j=2", -- ограничить кол-во ядер процессора
            "--malloc-trim", -- принудительно возврвщаать память системе
          },
        },
      },
    },
  },
}
