return {

    -- Which-key group + autocommands
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            defaults = {
                ["<leader>i"] = { name = "+intuition" },
            },
        },
        config = function(_, opts)
            require("which-key").setup(opts)

            -- Auto-populate templates with concept/timestamp
            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = "~/.local/share/nvim/intuition/concepts/*/*.md",
                callback = function(ev)
                    local folder_name = vim.fn.fnamemodify(ev.file, ":h:t")
                    local concept = folder_name:match("_(.+)$") or folder_name

                    local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
                    for i, line in ipairs(lines) do
                        line = line:gsub("{{CONCEPT}}", concept:gsub("-", " "):gsub("^%l", string.upper))
                        line = line:gsub("{{TIMESTAMP}}", folder_name:match("^(%d+_%d+)") or "")
                        vim.api.nvim_buf_set_lines(0, i - 1, i, false, { line })
                    end
                end,
            })

            -- Go support for invent/ folder
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "~/.local/share/nvim/intuition/concepts/*/invent/*.go",
                callback = function()
                    vim.bo.filetype = "go"
                    vim.keymap.set("n", "<leader>r", ":!go run %<CR>", { buffer = true, desc = "Run Go" })
                end,
            })
        end,
    },

    -- Telescope helper for browsing concepts
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>li",
                "<cmd>Telescope find_files cwd=~/.local/share/nvim/intuition/concepts<CR>",
                desc = "Intuition concepts",
            },
        },
    },
}
