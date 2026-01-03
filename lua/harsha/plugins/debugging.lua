return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-treesitter/nvim-treesitter",
		"mxsdev/nvim-dap-vscode-js",
		-- add vim-tes config
		-- "vim-test/vim-test"
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("dap-go").setup()
		require("dapui").setup()
		require("dap-python").setup("~/.virtualenvs/debugpy/bin/python3")
		require("nvim-dap-virtual-text").setup()

		require("dap-vscode-js").setup({
			node_path = "node",
			debugger_path = vim.fn.stdpath("data") .. "/vscode-js-debug",
			adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal" },
		})

		-- Debugging configurations for JS/TS (example: Jest)
		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Jest Tests",
				runtimeExecutable = "node",
				runtimeArgs = { "./node_modules/jest/bin/jest.js", "--runInBand" },
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
		}
		dap.configurations.typescript = dap.configurations.javascript

		dap.set_log_level("DEBUG")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		dap.listeners.after.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.after.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})

		-- vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>", {silent = true})
		-- vim.keymap.set("n", "<leader>tf", ":TestFile<CR>", {silent = true})
		-- vim.keymap.set("n","<leader>ta",":TestSuite<CR>",{silent = true})
		-- vim.keymap.set("n","<leader>tl",":TestLast<CR>",{silent = true})
		-- vim.keymap.set("n","<leader>tv",":TestVisit<CR>",{silent = true})

		require("dap-python").test_runner = "pytest"
		-- test python
		-- debug python method
		vim.keymap.set("n", "<leader>dpm", function()
			require("dap-python").test_method()
		end, { desc = "debug python method" })

		-- debug python class
		vim.keymap.set("n", "<leader>dpc", function()
			require("dap-python").test_class()
		end, { desc = "debug python test class" })
		-- debug python file
		vim.keymap.set("n", "<leader>dpf", function()
			require("dap-python").debug_selection()
		end, { desc = "debug python file" })

		-- test debug for go
		-- debug go test
		vim.keymap.set("n", "<leader>dgm", function()
			require("dap-go").debug_test()
		end, { desc = "debug go test method" })
		-- debug go test
		vim.keymap.set("n", "<leader>dgl", function()
			require("dap-go").debug_last_test()
		end, { desc = "debug last tested method" })

		-- debug js method
		vim.keymap.set("n", "<leader>djm", function()
			dap.continue()
		end, { desc = "debug JS/TS tests" })
	end,
}
