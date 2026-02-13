local map = vim.keymap.set

-- All keybindings use only:
--   Ctrl+letter, Alt+letter, F-keys, Shift+H/L, g-prefixed, Space-leader
-- (Terminal.app over SSH does NOT support Ctrl+Shift, Ctrl+Alt combos)

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("bnext")
    if vim.api.nvim_get_current_buf() == buf then
        vim.cmd("enew")
    end
    pcall(vim.api.nvim_buf_delete, buf, {})
end, { desc = "Close buffer (keep layout)" })

-- Move lines (Alt+Up/Down)
map("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Navigate back/forward (Ctrl+o / Ctrl+i are vim built-ins, always work)
-- No extra binding needed: Ctrl+o = back, Ctrl+i = forward

-- Half-page jumps (centered)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Paste without overwriting clipboard
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- Save
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Build (Alt+B)
map("n", "<A-b>", "<cmd>make<CR>", { desc = "Build project" })

-- Diagnostics (Alt+M)
map("n", "<A-m>", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics panel" })

-- Search in project (Space sg, or also Alt+G as a quick shortcut)
map("n", "<A-g>", "<cmd>Telescope live_grep<CR>", { desc = "Search in project" })

-- Format file (Alt+F)
map("n", "<A-f>", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })

-- Toggle mouse for terminal copy/paste
map("n", "<leader>m", function()
    if vim.o.mouse == "a" then
        vim.o.mouse = ""
        vim.notify("Mouse OFF — select with mouse, Cmd+C to copy")
    else
        vim.o.mouse = "a"
        vim.notify("Mouse ON")
    end
end, { desc = "Toggle mouse (for copy/paste)" })

-- Diagnostics navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })
