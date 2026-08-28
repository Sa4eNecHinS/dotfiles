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
        pyright = {
          enabled = false,
        },
        pylsp = {
          plugins = {
            -- formatter options
            black = { enabled = true },
            autopep8 = { enabled = false },
            yapf = { enabled = false },
            -- linter options
            pylint = { enabled = true, executable = "pylint" },
            ruff = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            -- type checker
            pylsp_mypy = {
              enabled = true,
              report_progress = true,
              live_mode = false,
            },
            -- auto-completion options
            jedi_completion = { fuzzy = true },
            -- import sorting
            isort = { enabled = true },
          },
        },
      },
      marksman = false,
    },
  },
}
