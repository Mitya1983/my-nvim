-- Options carried over from .vimrc + modern defaults
local opt = vim.opt

-- Indentation (from .vimrc: tabstop=4, shiftwidth=4, expandtab)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line numbers (from .vimrc: number) + relative for fast jumping
opt.number = true
opt.relativenumber = true

-- Cursor guides (from .vimrc: cursorline, cursorcolumn)
opt.cursorline = true
opt.cursorcolumn = true

-- Spell checking (from .vimrc)
opt.spell = true
opt.spelllang = "en_us"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.showmode = false -- shown by lualine instead
opt.laststatus = 3 -- global statusline
opt.splitright = true
opt.splitbelow = true
opt.pumheight = 15 -- completion menu height

-- History & undo
opt.history = 1000
opt.undofile = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menuone,noselect"

-- Clipboard: use OSC 52 to sync yank with Mac clipboard over SSH
vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
        ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
}
opt.clipboard = "unnamedplus" -- all yank/delete goes to system clipboard

-- Project-local config: source .nvim.lua from project root
opt.exrc = true

-- File handling
opt.fileencoding = "utf-8"
opt.backup = false
opt.swapfile = false

-- .zsh filetype (from .vimrc)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.zsh",
    callback = function() vim.bo.filetype = "sh" end,
})
