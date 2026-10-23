return {
  "dstein64/nvim-scrollview",
  event = "VeryLazy",
  opts = {
    current_only = true, -- only draw it in the focused window
    signs_on_startup = { "diagnostics", "search" },
  },
}
