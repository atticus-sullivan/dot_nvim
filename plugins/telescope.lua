local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values

require('telescope').setup{
	defaults = vim.tbl_extend('force', require('telescope.themes').get_ivy(), {
	}),
	pickers = {
		find_files = {
			theme = "ivy",
		}
	},
}

local live_multigrep = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job {
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			---@diagnostic disable-next-line: deprecated
			return vim.tbl_flatten {
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
			}
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	}

	pickers.new(opts, {
		debounce = 100,
		prompt_title = "Multi Grep",
		finder = finder,
		previewer = conf.grep_previewer(opts),
		sorter = require("telescope.sorters").empty(),
	}):find()
end

vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
vim.keymap.set("n", "<space>fgr", live_multigrep)
vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
vim.keymap.set("n", "<space>fgf", require("telescope.builtin").git_files)
vim.keymap.set("n", "<space>fgc", require("telescope.builtin").git_commits)
vim.keymap.set("n", "<space>fgs", require("telescope.builtin").git_status)
