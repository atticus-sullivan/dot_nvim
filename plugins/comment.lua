local c = require"Comment"

c.setup{
	opleader = {
		-- line-comment
		line  = "gc",
		-- block comment
		block = "gb"
	},

	mappings = {
		-- gcc -> line-comment current line
		-- gcb -> block-comment current line
		-- gc[count]{motion} -> line-comment motion
		-- gb[count]{motion} -> block-comment motion
		basic = true,

		-- gco, gcO, gcA
		extra = true,
		}
}

local comment_ft = require"Comment.ft"
comment_ft.set("lua", {"--%s", "--[[%s]]"})
