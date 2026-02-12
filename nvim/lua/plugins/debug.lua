-- Debugging (CLion's debugger)
return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
        },
        keys = {
            { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
            { "<F7>", function() require("dap").step_into() end, desc = "Debug: Step Into (F7)" },
            { "<F8>", function() require("dap").step_over() end, desc = "Debug: Step Over (F8)" },
            { "<S-F8>", function() require("dap").step_out() end, desc = "Debug: Step Out (Shift+F8)" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            { "<leader>dB", function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, desc = "Conditional breakpoint" },
            { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
            { "<leader>dl", function() require("dap").run_last() end, desc = "Re-run last debug" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
            { "<A-r>", function() require("dapui").toggle() end, desc = "Run/debug panel (Alt+R)" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Auto open/close debug UI
            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- C/C++ debugger via GDB
            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
            }

            dap.configurations.cpp = {
                {
                    name = "Launch (GDB)",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = false,
                    setupCommands = {
                        {
                            text = "-enable-pretty-printing",
                            description = "Enable pretty printing",
                            ignoreFailures = false,
                        },
                    },
                },
                {
                    name = "Attach to process",
                    type = "cppdbg",
                    request = "attach",
                    processId = require("dap.utils").pick_process,
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            }
            dap.configurations.c = dap.configurations.cpp

            -- Python debugger
            require("dap-python").setup("python3")

            -- Breakpoint appearance
            vim.fn.sign_define("DapBreakpoint", {
                text = "●", texthl = "DiagnosticError",
            })
            vim.fn.sign_define("DapStopped", {
                text = "▶", texthl = "DiagnosticInfo", linehl = "CursorLine",
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim", "nvim-dap" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "cppdbg", "debugpy" },
            })
        end,
    },
}
