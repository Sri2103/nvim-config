return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "markdown" },
		opts = {
			enabled = true,
			render_modes = { "n", "c", "t" },
			file_types = { "markdown", "markdown.mdx" },
			renders = {
				enabled = true,
			},
			completions = {
				completions = { lsp = { enabled = true } },
			},
		},
		keys = {
			{ "<leader>mm", "<cmd>RenderMarkdown toggle<CR>", desc = "Markdown preview" },
			{ "<leader>mr", "<cmd>RM!<CR>", desc = "Refresh Markdown" },
		},
	},
}
