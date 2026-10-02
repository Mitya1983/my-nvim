return {
  "jake-stewart/multicursor.nvim",
  version = "*",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    -- add cursor above/below
    vim.keymap.set({ "n", "v" }, "<M-Up>", function()
      mc.lineAddCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, "<M-Down>", function()
      mc.lineAddCursor(1)
    end)

    -- add cursor at next/prev match of word under cursor (like VSCode's Ctrl+D)
    vim.keymap.set({ "n", "v" }, "<C-n>", function()
      mc.matchAddCursor(1)
    end)
    vim.keymap.set({ "n", "v" }, "<C-p>", function()
      mc.matchAddCursor(-1)
    end)

    -- manually drop a cursor anywhere with the mouse
    vim.keymap.set("n", "<C-LeftMouse>", mc.handleMouse)

    -- once cursors exist, normal editing commands apply to all of them,
    -- including paste
    vim.keymap.set({ "n", "v" }, "<leader>a", mc.matchAllAddCursors)

    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "v" }, "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
}
