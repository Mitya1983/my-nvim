return {
  {
    "saghen/blink.cmp",
    opts = {
      snippets = {
        preset = "luasnip",
      },
      keymap = {
        ["<Tab>"] = { "snippet_forward", "select_and_accept", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
}
