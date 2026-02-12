-- Editor enhancements
return {
    -- Auto-pairs for brackets/quotes (like CLion)
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
            -- Integrate with cmp
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Comment toggle (like CLion's Ctrl+/)
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Toggle line comment" },
            { "gc", mode = "v", desc = "Toggle comment" },
            { "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
                mode = "n", desc = "Toggle comment (Ctrl+/)" },
            { "<C-/>", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                mode = "v", desc = "Toggle comment (Ctrl+/)" },
        },
        config = true,
    },

    -- Surround: change/add/delete surrounding chars (like CLion's Ctrl+Shift+Delete for unwrap)
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },

    -- Terminal (CLion: Alt+T)
    {
        "akinsho/toggleterm.nvim",
        keys = {
            { "<A-t>", "<cmd>ToggleTerm direction=horizontal<CR>",
                mode = { "n", "t" }, desc = "Toggle terminal (Alt+T)" },
            { "<C-`>", "<cmd>ToggleTerm direction=horizontal<CR>",
                mode = { "n", "t" }, desc = "Toggle terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
        },
        config = function()
            require("toggleterm").setup({
                size = 15,
                shade_terminals = true,
            })
        end,
    },

    -- Highlight TODO/FIXME/HACK comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },

    -- Trouble: better diagnostics list (like CLion's Problems panel)
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (problems panel)" },
            { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
        },
        config = true,
    },
}
