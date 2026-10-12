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

vim.api.nvim_create_user_command("DapNoExceptions", function()
  local dap = require("dap")
  if not dap.session() then
    vim.notify("No active debug session", vim.log.levels.WARN)
    return
  end
  dap.set_exception_breakpoints({})
  vim.notify("Exception breakpoints disabled")
end, { desc = "Disable DAP exception breakpoints" })

vim.keymap.set("n", "<leader>dx", "<cmd>DapNoExceptions<cr>", { desc = "Disable exception breakpoints" })

local dap_adapter = "codelldb" -- switch to "gdb" to use gdb instead

local function dap_run_exe(name, rel_path)
  return function(opts)
    local root = vim.fn.getcwd()
    local program = root .. "/" .. rel_path
    if not vim.uv.fs_stat(program) then
      vim.notify("Executable not found: " .. program, vim.log.levels.ERROR)
      return
    end
    require("dap").run({
      name = name,
      type = dap_adapter,
      request = "launch",
      program = program,
      args = opts.fargs,
      cwd = root,
      stopOnEntry = false,
    })
  end
end

vim.api.nvim_create_user_command(
  "DapRunCoreTests",
  dap_run_exe("Kobol core tests", "build/Debug/kobol/core/tests/kobol-core-tests"),
  { nargs = "*", desc = "Debug Kobol core tests (no build)" }
)

vim.api.nvim_create_user_command(
  "DapRunMain",
  dap_run_exe("Kobol manual_testing", "build/Debug/manual_testing/manual_testing"),
  { nargs = "*", desc = "Debug Kobol manual_testing (no build)" }
)
