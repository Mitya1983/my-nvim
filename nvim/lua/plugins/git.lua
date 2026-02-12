-- Git integration (CLion's Git panel, blame, diff)
return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    -- Navigation between hunks (like CLion's gutter arrows)
                    map("n", "]c", gs.next_hunk, "Next git change")
                    map("n", "[c", gs.prev_hunk, "Previous git change")

                    -- Actions
                    map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
                    map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>gb", gs.blame_line, "Blame line (CLion Annotate)")
                    map("n", "<leader>gd", gs.diffthis, "Diff against index")
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gwrite", "Gread", "Gdiffsplit", "Glog" },
        keys = {
            { "<leader>gg", "<cmd>Git<CR>", desc = "Git status" },
        },
    },
}
