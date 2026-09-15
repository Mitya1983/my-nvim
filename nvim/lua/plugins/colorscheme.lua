-- Colorscheme: catppuccin mocha + CLion Darcula-style overrides
return {
  -- LazyVim already ships a catppuccin spec, so only extend its opts
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      -- Custom highlights matched to CLion Darcula_copy.icls
      custom_highlights = function(colors)
        return {
          -- Base UI (TEXT: fg=#a9b7c6 bg=#111111)
          Normal = { fg = "#a9b7c6", bg = "#111111" },
          NormalNC = { fg = "#a9b7c6", bg = "#111111" },
          NormalFloat = { fg = "#a9b7c6", bg = "#1a1a1a" },
          Visual = { bg = "#616161" },
          CursorLine = { bg = "#1a1a1a" },
          LineNr = { fg = "#555555" },
          CursorLineNr = { fg = "#ffff55", bold = true },

          -- Comments: line/block = #55ffff normal, doc = #55ffff italic
          Comment = { fg = "#55ffff", italic = false },
          ["@comment"] = { fg = "#55ffff", italic = false },
          ["@comment.documentation"] = { fg = "#55ffff", italic = true },

          -- Doc comment tags: @param etc = #55ff55 bold+italic underline
          ["@keyword.documentation"] = { fg = "#55ff55", bold = true, italic = true, underline = true },
          ["@attribute.documentation"] = { fg = "#55ff55", bold = true, italic = true, underline = true },
          -- Doc tag values = #c0c0c0
          ["@variable.parameter.documentation"] = { fg = "#c0c0c0" },

          -- Keywords = #ffff55 italic (all keyword subgroups)
          Keyword = { fg = "#ffff55", italic = true },
          ["@keyword"] = { fg = "#ffff55", italic = true },
          ["@keyword.return"] = { fg = "#ffff55", italic = true },
          ["@keyword.function"] = { fg = "#ffff55", italic = true },
          ["@keyword.operator"] = { fg = "#ffff55", italic = true }, -- static_cast, new, delete, and, or
          ["@keyword.conditional"] = { fg = "#ffff55", italic = true }, -- if, else, switch
          ["@keyword.repeat"] = { fg = "#ffff55", italic = true }, -- for, while, do
          ["@keyword.type"] = { fg = "#ffff55", italic = true }, -- class, enum, template, typename
          ["@keyword.modifier"] = { fg = "#ffff55", italic = true }, -- const, public, private, virtual
          ["@keyword.exception"] = { fg = "#ffff55", italic = true }, -- throw, noexcept
          ["@keyword.coroutine"] = { fg = "#ffff55", italic = true }, -- co_await, co_yield
          StorageClass = { fg = "#ffff55", italic = true },
          Conditional = { fg = "#ffff55", italic = true },
          Repeat = { fg = "#ffff55", italic = true },
          Statement = { fg = "#ffff55", italic = true },
          Exception = { fg = "#ffff55", italic = true },

          -- self/this = #ffff55 (like keywords)
          ["@variable.builtin"] = { fg = "#ffff55", italic = true },

          -- auto = #ffff55 italic (it's a keyword, not a type name)
          ["@type.builtin"] = { fg = "#ffff55", italic = true },

          -- Types / classes / interfaces / structs = #55ff55
          Type = { fg = "#55ff55" },
          ["@type"] = { fg = "#55ff55" },
          ["@type.definition"] = { fg = "#55ff55" },

          -- Namespace = #55ff55 italic
          ["@module"] = { fg = "#55ff55", italic = true },
          ["@namespace"] = { fg = "#55ff55", italic = true },

          -- Enum constants = #55ff55 italic
          ["@constant"] = { fg = "#55ff55", italic = true },

          -- Other constants = #ffffff bold+italic
          Constant = { fg = "#ffffff", bold = true, italic = true },
          ["@constant.builtin"] = { fg = "#ffffff", bold = true, italic = true },
          ["@constant.macro"] = { fg = "#ffffff", bold = true, italic = true },
          Boolean = { fg = "#ffffff", bold = true, italic = true },

          -- Strings = #ff55ff
          String = { fg = "#ff55ff" },
          ["@string"] = { fg = "#ff55ff" },
          Character = { fg = "#ff55ff" },

          -- Numbers = #ff55ff
          Number = { fg = "#ff55ff" },
          ["@number"] = { fg = "#ff55ff" },
          Float = { fg = "#ff55ff" },

          -- Include path = #ff55ff (like strings)
          ["@string.special.path"] = { fg = "#ff55ff" },

          -- Function declaration = #a9b7c6 bold
          ["@function"] = { fg = "#a9b7c6", bold = true },
          ["@function.method"] = { fg = "#a9b7c6", bold = true },

          -- Function call = bold+italic
          ["@function.call"] = { fg = "#a9b7c6", bold = true, italic = true },
          ["@function.method.call"] = { fg = "#a9b7c6", bold = true, italic = true },
          Function = { fg = "#a9b7c6", bold = true },

          -- Static method = #ffffff bold+italic
          ["@function.builtin"] = { fg = "#ffffff", bold = true, italic = true },

          -- Variables: normal = #a9b7c6
          ["@variable"] = { fg = "#a9b7c6" },
          ["@variable.member"] = { fg = "#a9b7c6" },
          ["@variable.parameter"] = { fg = "#a9b7c6" },
          Identifier = { fg = "#a9b7c6" },

          -- Global variable = #a9b7c6 bold+italic (treesitter may not distinguish this)
          -- Static field = #a9b7c6 italic
          ["@property"] = { fg = "#a9b7c6" },

          -- Operators / dot = #cc7832
          Operator = { fg = "#cc7832" },
          ["@operator"] = { fg = "#cc7832" },
          ["@punctuation.delimiter"] = { fg = "#cc7832" },
          -- Keep brackets/parens as normal text
          ["@punctuation.bracket"] = { fg = "#a9b7c6" },

          -- Preprocessor / directives = #5555ff
          PreProc = { fg = "#5555ff" },
          Include = { fg = "#5555ff" },
          Define = { fg = "#5555ff" },
          Macro = { fg = "#5555ff" },
          ["@keyword.import"] = { fg = "#5555ff" },
          ["@keyword.import.cpp"] = { fg = "#5555ff" },
          ["@keyword.directive"] = { fg = "#5555ff" },
          -- Macro names = #5555ff
          ["@function.macro"] = { fg = "#5555ff" },

          -- Diagnostics (from ICLS ERRORS/WARNING/INFO_ATTRIBUTES)
          DiagnosticError = { fg = "#e8130d" },
          DiagnosticWarn = { fg = "#be9117" },
          DiagnosticInfo = { fg = "#c7c706" },
          DiagnosticHint = { fg = "#55ff55" },

          -- Warning background highlight
          DiagnosticUnderlineWarn = { sp = "#be9117", undercurl = true },
          DiagnosticUnderlineError = { sp = "#e8130d", undercurl = true },
          DiagnosticUnderlineInfo = { sp = "#c7c706", undercurl = true },

          -- Unused code = #72737a italic underline
          DiagnosticUnnecessary = { fg = "#72737a", italic = true, underline = true },
        }
      end,
    },
  },

  -- Tell LazyVim to use catppuccin. Use the flavour-specific name: Neovim 0.12+
  -- bundles its own "catppuccin" colorscheme, which shadows the plugin's.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
