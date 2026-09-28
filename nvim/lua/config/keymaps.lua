-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- GitLab CLI (glab) integration via floating terminal
-- Requires: glab installed and authenticated (glab auth status)

vim.keymap.set("n", "<leader>gI", function()
  Snacks.terminal("glab issue list", { win = { style = "float" }, auto_close = false })
end, { desc = "GitLab: List issues" })

vim.keymap.set("n", "<leader>gM", function()
  Snacks.terminal("glab mr list", { win = { style = "float" }, auto_close = false })
end, { desc = "GitLab: List merge requests" })

vim.keymap.set("n", "<leader>gV", function()
  Snacks.terminal("glab mr view", { win = { style = "float" }, auto_close = false })
end, { desc = "GitLab: View current branch's MR" })
