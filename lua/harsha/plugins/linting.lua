return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        local eslint = lint.linters.eslint_d

        -- if Eslint error configuration not found : change MasonInstall eslint@version or npm i -g eslint at a specific version
        lint.linters_by_ft = {
            javascript = { "biomejs" },
            typescript = { "biomejs" },
            javascriptreact = { "biomejs" },
            typescriptreact = { "biomejs" },
            svelte = { "biomejs" },
            python = { "pylint" },
            go = { "golangcilint", "staticcheck" },
            bash = { "shellcheck" },
        }

        eslint.args = {
            "--no-warn-ignored",
            "--format",
            "json",
            "--stdin",
            "--stdin-filename",
            function()
                return vim.fn.expand("%:p")
            end,
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })

        vim.keymap.set("n", "<leader>l", function()
            lint.try_lint()
        end, { desc = "Trigger linting for current file" })

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = lint_augroup,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
}
