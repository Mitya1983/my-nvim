-- LSP: code intelligence (CLion's core feature)
-- Uses Neovim 0.11 native vim.lsp.config API + Mason for server installation
return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",  -- C/C++
                    "pyright", -- Python
                    "lua_ls",  -- Lua (for nvim config editing)
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- LSP keymaps (set when an LSP attaches to a buffer)
            -- All bindings use: g-prefixed motions, Space-leader, F-keys, or simple Ctrl+letter
            -- (Terminal.app over SSH doesn't support Ctrl+Shift or Ctrl+Alt combos)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local buf = ev.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
                    end

                    -- Navigation
                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gr", vim.lsp.buf.references, "Find usages")
                    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
                    map("n", "K", vim.lsp.buf.hover, "Quick documentation")
                    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
                    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

                    -- Refactoring
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<F6>", vim.lsp.buf.rename, "Rename symbol")

                    -- Code actions
                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

                    -- Formatting
                    map("n", "<leader>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, "Format file")

                    -- Switch header/source (clangd-specific, uses LSP request directly)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if client and client.name == "clangd" then
                        local switch = function()
                            local params = { uri = vim.uri_from_bufnr(0) }
                            client:request("textDocument/switchSourceHeader", params, function(err, result)
                                if result then
                                    vim.cmd("edit " .. vim.uri_to_fname(result))
                                end
                            end, buf)
                        end
                        map("n", "<F10>", switch, "Switch header/source")
                        map("n", "<leader>o", switch, "Switch header/source")
                    end
                end,
            })

            -- Neovim 0.11 native LSP configuration
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            })

            vim.lsp.config("pyright", {
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            library = { vim.env.VIMRUNTIME },
                        },
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            vim.lsp.enable({ "clangd", "pyright", "lua_ls" })

            -- Diagnostic appearance
            vim.diagnostic.config({
                virtual_text = { spacing = 4, prefix = "●" },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded" },
            })
        end,
    },
}
