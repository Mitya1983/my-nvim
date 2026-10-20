-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }
vim.opt.guicursor = table.concat({
  "n-v-c:block",
  "i-ci-ve:ver25-iCursor",
  "r-cr:hor20",
  "o:hor50",
  "a:blinkwait700-blinkoff400-blinkon250",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}, ",")

vim.api.nvim_set_hl(0, "iCursor", { bg = "#FF3131", fg = "#000000" })

-- Terminal tab title = project name.
-- Writes OSC 2 directly, which works over SSH where Neovim's own 'title'
-- detection doesn't. Leave vim.opt.title off so the two don't fight.
local function set_title(name)
  vim.api.nvim_chan_send(vim.v.stderr, "\27]2;" .. name .. "\7")
end

local function update_title()
  local ok, root = pcall(function()
    return LazyVim.root()
  end)
  if not ok or not root or root == "" then
    root = vim.fn.getcwd()
  end
  set_title(vim.fn.fnamemodify(root, ":t"))
end

-- Restore a neutral title when leaving Neovim (a local shell won't do it for us)
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("kobol_terminal_title_restore", { clear = true }),
  callback = function()
    set_title(vim.fn.fnamemodify(vim.fn.getcwd(), ":~"))
  end,
})

-- Put the project title back when resuming from :suspend / Ctrl-Z
vim.api.nvim_create_autocmd("VimResume", {
  callback = function()
    vim.schedule(update_title)
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "DirChanged", "FocusGained" }, {
  group = vim.api.nvim_create_augroup("kobol_terminal_title", { clear = true }),
  callback = function()
    vim.schedule(update_title)
  end,
})

if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52 (copy only)",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
  vim.opt.clipboard = "unnamedplus"
end
