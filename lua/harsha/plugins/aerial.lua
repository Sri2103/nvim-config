return {
    {

        "stevearc/aerial.nvim",
        event = "VeryLazy",
        dependencies = {
            "folke/snacks.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-lualine/lualine.nvim",
            "ibhagwan/fzf-lua",
        },
        config = function()
            require("aerial").setup({
                backends = { "lsp", "treesitter" },
                layout = { min_width = 30, max_width = { 40, 0.2 } },
                attach_mode = "window",
                lazy_load = true,
                filter_kind = false, -- Show all symbol kinds (customize as needed)

                keymaps = {
                    ["j"] = "actions.down",    -- Move down the symbol list
                    ["k"] = "actions.up",      -- Move up the symbol list
                    ["<CR>"] = "actions.jump", -- Jump to the selected symbol
                    ["o"] = "actions.tree_toggle", -- Fold/unfold subtree
                    ["za"] = "actions.tree_toggle", -- Fold/unfold subtree (alt)
                    ["O"] = "actions.tree_toggle_recursive", -- Fold/unfold all within node
                    ["zA"] = "actions.tree_toggle_recursive", -- Same as above (alt)
                    ["zc"] = "actions.tree_close", -- Fold current node
                    ["h"] = "actions.tree_close", -- Fold current node (alt)
                    ["zo"] = "actions.tree_open", -- Unfold current node
                    ["l"] = "actions.tree_open", -- Unfold current node (alt)
                    ["zM"] = "actions.tree_close_all", -- Fold all
                    ["zR"] = "actions.tree_open_all", -- Unfold all
                    ["{"] = "actions.prev",    -- Jump to previous symbol
                    ["}"] = "actions.next",    -- Jump to next symbol
                    ["q"] = "actions.close",   -- Close the aerial window
                    ["?"] = "actions.show_help", -- Show keymap/help popup
                    ["g?"] = "actions.show_help", -- Show help (alt)
                    ["<LeftMouse>"] = "actions.jump", -- Mouse: jump to symbol
                    ["<2-LeftMouse>"] = "actions.jump", -- Mouse: double-click jump
                    -- Optional extras:
                    ["gg"] = "actions.tree_sync_top", -- Go to top of list
                    ["G"] = "actions.tree_sync_bottom", -- Go to bottom of list
                    ["*"] = "actions.tree_filter", -- Filter outline by word
                    ["/"] = "actions.tree_filter", -- Begin search/filter
                    ["<Esc>"] = "actions.tree_filter_clear", -- Clear filter/search
                },
            })

            -- Toggle aerial outline window
            vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle!<CR>", { desc = "Aerial Toggle" })

            -- Aerial Snacks Picker (symbol select popup)
            vim.keymap.set("n", "<leader>as", function()
                require("aerial").snacks_picker({ layout = { preset = "ivy" } }) -- Change the layout as you prefer
            end, { desc = "Aerial Symbols (snacks picker)" })

            -- Aerial fzf-lua picker
            vim.keymap.set("n", "<leader>af", function()
                require("aerial").fzf_lua_picker()
            end, { desc = "Aerial Symbols (fzf-lua)" })

            -- Telescope aerial extension (load only if available)
            local telescope_ok, telescope = pcall(require, "telescope")
            if telescope_ok then
                telescope.load_extension("aerial")
                vim.keymap.set("n", "<leader>at", function()
                    telescope.extensions.aerial.aerial()
                end, { desc = "Aerial Symbols (Telescope)" })
            end

            -- Lualine statusline integration
            local lualine_ok, lualine = pcall(require, "lualine")
            if lualine_ok then
                lualine.setup({
                    sections = {
                        lualine_x = {
                            { "aerial", sep = " > ", desnse = true, colored = true },
                        },
                    },
                })
            end
        end,
    },
}
