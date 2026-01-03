local M = {}

local base_dir = vim.fn.expand("~/.local/share/nvim/intuition")
local templates_dir = base_dir .. "/templates"
local concepts_dir = base_dir .. "/concepts"
local truths_dir = base_dir .. "/truths"
local sessions_dir = base_dir .. "/sessions"

M.base_dir = base_dir
M.sessions_path = sessions_dir .. "/today.md"
M.truths_dir = truths_dir

-- Create a new session for today
function M.start_session()
	vim.fn.mkdir(sessions_dir, "p")
	local session_path = M.sessions_path

	local exists = vim.fn.filereadable(session_path) == 1

	vim.cmd("edit " .. session_path)

	if not exists or vim.api.nvim_buf_line_count(0) == 1 and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
		local tpl = templates_dir .. "/today.md"
		local f = io.open(tpl, "r")
		if f then
			local data = f:read("*a")
			f:close()
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
			vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(data, "\n"))
			vim.cmd("write")
		end
	end
end

-- Create new timestamped concept folder
function M.new_concept()
	local concept = vim.fn.input("Concept name: ")
	if concept == "" then
		return
	end

	local timestamp = os.date("%Y-%m-%d_%H%M")
	local safe_concept = concept:gsub("[^%w%-]", "-"):lower()
	local folder_name = string.format("%s_%s", timestamp, safe_concept)
	local folder_path = concepts_dir .. "/" .. folder_name

	-- Create folder structure
	os.execute("mkdir -p " .. folder_path .. "/{details,invent}")

	-- Copy templates
	os.execute("cp " .. templates_dir .. "/concept.md " .. folder_path .. "/big-picture.md")
	os.execute("cp " .. templates_dir .. "/buffer.go " .. folder_path .. "/invent/main.go")

	-- Open big-picture.md
	vim.cmd("edit " .. folder_path .. "/big-picture.md")
	print("Created: " .. folder_path)
end

-- Save truth to final truths/ folder
function M.save_truth()
	local current_file = vim.fn.expand("%:p")
	if not current_file:match("truth%.md$") then
		print("Must be in truth.md file")
		return
	end

	local folder_name = vim.fn.fnamemodify(current_file, ":h:t")
	local truth_name = folder_name:gsub("_", "-") .. ".md"
	local dest_path = truths_dir .. "/" .. truth_name

	os.execute("cp '" .. current_file .. "' '" .. dest_path .. "'")
	print("✅ Truth saved: " .. dest_path)
end

-- Generate review file
function M.review_truths()
	local truths = vim.fn.glob(truths_dir .. "/*.md", true, true)
	local review_path = base_dir .. "/review/week-" .. os.date("%U") .. ".md"

	vim.cmd("edit " .. review_path)

	local lines = { "# Week " .. os.date("%U") .. " Review", "", "## Truths Learned" }

	for _, truth_file in ipairs(truths) do
		local fh = io.open(truth_file, "r")
		if fh then
			local first_line = fh:read("*l")
			fh:close()
			if first_line:match("# Truth:") then
				table.insert(lines, "- " .. vim.fn.fnamemodify(truth_file, ":t"))
			end
		end
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	print("Review generated: " .. review_path)
end

return M
