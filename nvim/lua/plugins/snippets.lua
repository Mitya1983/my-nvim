return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      history = false,
      region_check_events = "InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      require("luasnip.loaders.from_vscode").lazy_load({
        paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
      })

      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/lua/snippets",
      })
    end,
  },
}
