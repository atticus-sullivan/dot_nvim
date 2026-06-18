local ls        = require"luasnip"
local s         = ls.snippet
local sn        = ls.snippet_node
local isn       = ls.indent_snippet_node
local t         = ls.text_node
local i         = ls.insert_node
local f         = ls.function_node
local c         = ls.choice_node
local d         = ls.dynamic_node
local r         = ls.restore_node
local events    = require("luasnip.util.events")
local ai        = require("luasnip.nodes.absolute_indexer")
local rep       = require("luasnip.extras").rep
local fmt       = require("luasnip.extras.fmt").fmt
local types     = require("luasnip.util.types")
local util      = require("luasnip.util.util")
local node_util = require("luasnip.nodes.util")

local function bash(_, _, command)
	print(command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end

return {
	s("today", {
		f(bash, {}, {user_args={"date +%d.%m.%y"}})
	}),
	s("spoilerFree",
		fmt([[
			{{{{< spoiler series="{series}" book="{book}" chapter="{chapter}" >}}}}
			{here}
			{{{{< /spoiler >}}}}
		]], {
				series  = c(1, {t("royalRanger")}),
				book    = i(2, "6"),
				chapter = i(3),
				here    = i(0)
		})
	),
	s("ref",
		fmt([[
		[{nameA}]({{{{< relref "../{type}/{nameB}" >}}}})
		]], {
				nameA    = i(1),
				nameB    = rep(1),
				["type"] = c(2, {t"characters", t"concepts", t"events", t"locations"})
			})
	),
	s("note", 
		fmt([[
			# {title}
			Created: {date}

			{now}

			## References
			1. 
		]], {
				title = f(function(_,_,x) return vim.fn.expand(x) end, {}, {user_args={'%:t'}}),
				date = f(bash, {}, {user_args={"date +'%y-%m-%d %H:%M'"}}),
				now = i(0),
		})
	)
}
