-- File explorer (replaces NERDTree, CLion's Project panel)
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        -- Same binding as your .vimrc NERDTree toggle
        { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        { "<leader>n", "<cmd>NvimTreeFindFile<CR>", desc = "Locate file in tree (Alt+F1)" },
    },
    config = function()
        require("nvim-tree").setup({
            view = { width = 35 },
            renderer = {
                group_empty = true,
                icons = {
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                    },
                },
            },
            filters = {
                dotfiles = false,
                custom = { "^.git$" },
            },
            git = { enable = true },
            -- Auto-open when opening a directory (from your .vimrc)
            actions = {
                open_file = {
                    quit_on_open = false,
                },
            },
        })

        -- Open tree when nvim starts with a directory (from .vimrc)
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function(data)
                if vim.fn.isdirectory(data.file) == 1 then
                    vim.cmd.cd(data.file)
                    require("nvim-tree.api").tree.open()
                end
            end,
        })
    end,
}
