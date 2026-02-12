-- Treesitter: syntax highlighting + text objects
-- Note: Neovim 0.11 has built-in treesitter highlighting (auto-enabled when parsers exist).
-- This plugin manages parser installation. Textobjects are configured via keymaps.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Install parsers for these languages
            local parsers = {
                "c", "cpp", "python", "cmake", "lua",
                "bash", "json", "yaml", "markdown", "vim", "vimdoc",
                "make", "diff", "gitcommit",
            }
            local installed = require("nvim-treesitter").get_installed()
            local to_install = vim.tbl_filter(function(p)
                return not vim.tbl_contains(installed, p)
            end, parsers)
            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end

            -- Enable treesitter highlighting for all buffers that have a parser
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move = require("nvim-treesitter-textobjects.move")

            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            -- Text object selection keymaps (usable with d, c, y, v)
            local sel = function(query)
                return function() select.select_textobject(query) end
            end
            for _, mode in ipairs({ "x", "o" }) do
                vim.keymap.set(mode, "af", sel("@function.outer"), { desc = "Around function" })
                vim.keymap.set(mode, "if", sel("@function.inner"), { desc = "Inside function" })
                vim.keymap.set(mode, "ac", sel("@class.outer"), { desc = "Around class" })
                vim.keymap.set(mode, "ic", sel("@class.inner"), { desc = "Inside class" })
                vim.keymap.set(mode, "aa", sel("@parameter.outer"), { desc = "Around parameter" })
                vim.keymap.set(mode, "ia", sel("@parameter.inner"), { desc = "Inside parameter" })
            end

            -- Move between functions/classes
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer")
            end, { desc = "Next function" })
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer")
            end, { desc = "Previous function" })
            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer")
            end, { desc = "Next class" })
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer")
            end, { desc = "Previous class" })
        end,
    },
}
