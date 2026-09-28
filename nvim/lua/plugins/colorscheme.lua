local ui = {
  bg_dim = "#1e2326",
  bg_surface = "#323c41",
  green = "#a7c080",
  fg = "#d3c6aa",
  red = "#e67e80",
}

local syntax = {
  red = "#f07476",
  orange = "#f1946a",
  yellow = "#e4bf76",
  green = "#a8c67a",
  aqua = "#7dc68f",
  blue = "#79c1b7",
  purple = "#dc93b6",
}

return {
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,

    opts = {
      background = "hard",
      transparent_background_level = 1,

      italics = false,
      disable_italic_comments = false,

      sign_column_background = "none",
      ui_contrast = "high",

      colours_override = function(palette)
        -- syntax: slightly more saturated Everforest
        palette.red = syntax.red
        palette.orange = syntax.orange
        palette.yellow = syntax.yellow
        palette.green = syntax.green
        palette.aqua = syntax.aqua
        palette.blue = syntax.blue
        palette.purple = syntax.purple
      end,

      on_highlights = function(hl, palette)
        --
        -- base UI
        --
        hl.Normal = {
          fg = ui.fg,
          bg = palette.none,
        }

        hl.NormalNC = {
          fg = ui.fg,
          bg = palette.none,
        }

        hl.LineNr = {
          fg = palette.grey0,
          bg = palette.none,
        }

        hl.SignColumn = {
          bg = palette.none,
        }

        --
        -- floating windows
        --
        hl.NormalFloat = {
          fg = ui.fg,
          bg = ui.bg_surface,
        }

        hl.FloatBorder = {
          fg = ui.green,
          bg = ui.bg_surface,
        }

        --
        -- LazyVim / Snacks dashboard
        --
        hl.SnacksDashboardHeader = {
          fg = ui.green,
          bold = true,
        }

        hl.SnacksDashboardIcon = {
          fg = ui.green,
        }

        hl.SnacksDashboardDesc = {
          fg = ui.fg,
        }

        hl.SnacksDashboardKey = {
          fg = ui.green,
          bold = true,
        }

        --
        -- Neo-tree / rice-paper accent
        --
        hl.NeoTreeNormal = {
          bg = palette.none,
        }

        hl.NeoTreeNormalNC = {
          bg = palette.none,
        }

        hl.NeoTreeDirectoryName = {
          fg = ui.green,
        }

        hl.NeoTreeDirectoryIcon = {
          fg = ui.green,
        }

        hl.NeoTreeRootName = {
          fg = ui.green,
          bold = true,
        }

        hl.NeoTreeExpander = {
          fg = ui.green,
        }

        hl.NeoTreeIndentMarker = {
          fg = palette.grey0,
        }

        hl.NeoTreeWinSeparator = {
          fg = ui.bg_surface,
          bg = palette.none,
        }
      end,
    },

    config = function(_, opts)
      require("everforest").setup(opts)
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.o.background = "dark"
        require("everforest").load()
      end,
    },
  },
}
