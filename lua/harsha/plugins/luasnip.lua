-- lua/plugins/luasnip.lua
return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")

		-- =========================
		-- Core LuaSnip configuration
		-- =========================
		ls.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
			enable_autosnippets = false,
			region_check_events = "InsertEnter",
			delete_check_events = "TextChanged,InsertLeave",
		})

		-- =========================
		-- Load custom snippets
		-- =========================
		require("luasnip.loaders.from_lua").load({
			paths = vim.fn.stdpath("config") .. "/lua/harsha/snippets",
		})

		-- =========================
		-- Keymaps (NO nvim-cmp)
		-- =========================
		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			else
				return "<Tab>"
			end
		end, { expr = true, silent = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			else
				return "<S-Tab>"
			end
		end, { expr = true, silent = true })

		-- =========================
		-- Reload snippets without restart
		-- =========================
		vim.keymap.set("n", "<leader>rs", function()
			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath("config") .. "/lua/snippets",
			})
			print("LuaSnip snippets reloaded")
		end)
	end,
}
