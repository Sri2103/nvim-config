-- ~/.config/nvim/lua/harsha/core/custom-plugins/custom-flow.lua

local ok, I = pcall(require, "harsha.intuition")
if not ok then
	vim.notify("harsha.intuition error: " .. I, vim.log.levels.ERROR)
	return
end

vim.keymap.set("n", "<leader>it", I.start_session, { desc = "Intuition Today" })

vim.keymap.set("n", "<leader>ic", I.new_concept, { desc = "New Concept" })
vim.keymap.set("n", "<leader>itf", I.save_truth, { desc = "Save Truth" })
vim.keymap.set("n", "<leader>ir", I.review_truths, { desc = "Review Truths" })
