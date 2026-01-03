return {
	"gelguy/wilder.nvim",
	-- "nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"romgrk/fzy-lua-native",
	},
	lazy = false,
	config = function()
		local wilder = require("wilder")

		-- Enable Python remote plugin

		vim.g.python3_host_prog = "~/.virtualenvs/debugpy/bin/python3"
		wilder.setup({ modes = { ":", "/", "?" } })

		-- 🔥 Python pipelines enabled
		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.python_file_finder_pipeline({
					file_command = { "fd", "-tf" }, -- better performance
					dir_command = { "fd", "-td" },
					filters = { "fuzzy_filter" },
				}),
				wilder.cmdline_pipeline({
					language = "python",
					fuzzy = 1,
				}),
				wilder.python_search_pipeline({
					pattern = wilder.python_fuzzy_pattern(),
					-- omit to get results in the order they appear in the buffer
					sorter = wilder.python_difflib_sorter(),
					-- can be set to 're2' for performance, requires pyre2 to be installed
					-- see :h wilder#python_search() for more details
					engine = "re",
				})
			),
		})

		-- Define custom highlight groups

		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				min_width = "20%",
				max_height = "15%",
				reverse = 0,
				highlighter = {
					wilder.lua_pcre2_highlighter(),
					wilder.lua_fzy_highlighter(),
				},
				highlights = {
					default = wilder.make_hl(
						"WilderPopupMenu",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { background = "#1E212B" } }
					),
					accent = wilder.make_hl(
						"WilderAccent",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { foreground = "#58FFD6", background = "#1e1e2e" } }
					),
				},
				border = "single",
			}))
		)
	end,
}
