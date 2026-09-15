local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local i = ls.insert_node

-- Computes a header guard macro name from the file's path relative to project root
-- e.g. core/include/serializers/reader.hpp -> KOBOL_CORE_INCLUDE_SERIALIZERS_READER_HPP
local function header_guard()
  local filepath = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()
  local relpath = filepath:sub(#cwd + 2) -- strip cwd + leading slash
  return relpath:upper():gsub("[/%.]", "_")
end

ls.add_snippets("cpp", {
  s("copyr", {
    t({ "//", "// Create by Mitia Tristan on " }),
    f(function()
      return os.date("%Y-%m-%d")
    end),
    t({ "", "//" }),
  }),

  s("hguard", {
    t("#ifndef "),
    f(header_guard),
    t({ "", "#define " }),
    f(header_guard),
    t({ "", "" }),
    i(0),
    t({ "", "#endif // " }),
    f(header_guard),
  }),

  s("inc", {
    t("#include <"),
    i(1),
    t(">"),
  }),

  s("incl", {
    t('#include "'),
    i(1),
    t('"'),
  }),

  s("rfor", {
    t("for (auto& "),
    i(1, "item"),
    t(" : "),
    i(2, "container"),
    t({ ") {", "    " }),
    i(0),
    t({ "", "}" }),
  }),

  s("unus", {
    t("[[maybe_unused]]"),
  }),

  s("nodi", {
    t("[[nodiscard]]"),
  }),
})
