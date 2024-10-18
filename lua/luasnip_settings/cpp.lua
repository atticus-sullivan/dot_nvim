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

local function at_start_of_line(line_to_cursor, matched_trigger,_)
	return line_to_cursor == matched_trigger
end

return {
	-- https://github.com/L3MON4D3/Dotfiles/blob/master/.config/nvim/luasnippets/c.lua
	-- https://github.com/L3MON4D3/LuaSnip/issues/423
	-- https://neovim.io/doc/user/lua.html#lua-stdlib
	s({trig = "for(%w+)", wordTrig = true, regTrig = true}, fmt(
		[[for({1} {2}; {3}; {4}){{]] .. "\n" ..
		[[	{0}]] .. "\n" ..
		[[}}]],
		{
			[0] = i(0),
			[1] = i(1), -- TODO
			[2] = i(2), -- TODO
			[3] = i(3), -- TODO
			[4] = i(4), -- TODO
		}
	)),
} , {
	s("prag", t"#pragma once", {condition=at_start_of_line}),
	s("ns", fmt(
			"namespace {1} {{" .. "\n" ..
			"" .. "\n" ..
			"" .. "\n" ..
			"{0}" .. "\n" ..
			"" .. "\n" ..
			"" .. "\n" ..
			"}}",
			{
				[0] = i(0),
				[1] = i(1),
			}),
		{
			condition = at_start_of_line,
		}
	),
}
