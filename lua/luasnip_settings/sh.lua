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
local rep       = require("luasnip.extras").rep
local fmt       = require("luasnip.extras.fmt").fmt

local function at_start_of_line(line_to_cursor, matched_trigger,_)
	return line_to_cursor == matched_trigger
end

return {
} , {
	s("#!", fmt(
		[[
		#!/bin/bash
		{}]],
		{
			i(0),
		}),
		{
			condition = at_start_of_line,
		}),
}
