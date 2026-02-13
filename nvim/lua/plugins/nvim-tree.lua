-- File explorer (replaces NERDTree, CLion's Project panel)
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        { "<leader>n", "<cmd>NvimTreeFindFile<CR>", desc = "Locate file in tree" },
    },
    init = function()
        -- Disable netrw (must be set before netrw loads)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- Open tree when nvim starts with a directory
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function(data)
                if vim.fn.isdirectory(data.file) == 1 then
                    vim.cmd.cd(data.file)
                    require("nvim-tree.api").tree.open()
                end
            end,
        })
    end,
    config = function()
        local function my_on_attach(bufnr)
            local api = require("nvim-tree.api")
            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end
            -- Load all default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- Override Enter and o: always open files in editor window
            local function open_in_editor()
                local node = api.tree.get_node_under_cursor()
                if not node then return end

                -- Directories: expand/collapse normally
                if node.nodes then
                    api.node.open.edit()
                    return
                end

                local path = node.absolute_path
                if not path then return end

                -- Try to move to window right of tree
                local tree_win = vim.api.nvim_get_current_win()
                vim.cmd("wincmd l")

                -- If we didn't move (tree is the only window), create a split
                if vim.api.nvim_get_current_win() == tree_win then
                    vim.cmd("vsplit")
                    -- Resize tree back to its configured width
                    vim.api.nvim_set_current_win(tree_win)
                    vim.cmd("vertical resize 35")
                    vim.cmd("wincmd l")
                end

                vim.cmd("edit " .. vim.fn.fnameescape(path))
            end

            vim.keymap.set("n", "<CR>", open_in_editor, opts("Open in editor"))
            vim.keymap.set("n", "o", open_in_editor, opts("Open in editor"))
        end

        require("nvim-tree").setup({
            on_attach = my_on_attach,
            hijack_netrw = true,
            view = { width = 35 },
            renderer = {
                group_empty = true,
                icons = {
                    show = { git = true, folder = true, file = true },
                },
            },
            filters = {
                dotfiles = false,
                custom = { "^.git$" },
            },
            git = { enable = true },
            actions = {
                open_file = { quit_on_open = false },
            },
        })
    end,
}
