return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 1 },
            --{ id = "breakpoints", size = 0.1 },
            --{ id = "stacks", size = 0.125 },
          },
          size = 0.4, -- height in lines, since this is a bottom/top layout
          position = "bottom",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.1,
          position = "bottom",
        },
      },
    },
  },
}
