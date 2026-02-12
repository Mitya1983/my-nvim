-- Telescope: fuzzy finder (CLion's Search Everywhere / double Shift)
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    keys = {
        -- File navigation
        { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
        { "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Search in project" },
        { "<leader>sb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
        { "<leader>sw", "<cmd>Telescope grep_string<CR>", desc = "Search current word" },
        { "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "Search diagnostics" },
        { "<leader>sr", "<cmd>Telescope resume<CR>", desc = "Resume last search" },
        { "<leader>so", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
        { "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "Search help" },

        -- LSP via Telescope
        { "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>", desc = "File structure" },
        { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Search symbol" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
            },
        })
        telescope.load_extension("fzf")
    end,
}
