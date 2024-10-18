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
local l         = require('luasnip.extras').lambda
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
	s({trig="class", autotriggered=true}, fmt(
		[[{} = {{}} -- default values here]] .. "\n" ..
		[[function {}:new(o) -- key/value passing]] .. "\n" ..
		[[	o = o or {{}}]] .. "\n" ..
		[[	setmetatable(o, self) -- use the same metatable for all objects]] .. "\n" ..
		[[	self.__index = self -- lookup in class if key is not found]] .. "\n" ..
		[[	return o]] .. "\n" ..
		[[end]] .. "\n" ..
		[[-- instanciation]] .. "\n" ..
		[[obj = {}:new{{{}}}]] .. "\n" ..
		[[-- inheritance]] .. "\n" ..
		[[sub = {}:new() -- overwrite function as sub:foo]],
		{
			i(1, "className"),
			rep(1),
			rep(1),
			i(2, "attrs"),
			rep(1),
		}
	)),
	s("func decorator", fmt(
		[[mt = {{__concat =]] .. "\n" ..
		[[	function(a,f)]] .. "\n" ..
		[[		return function(...)]] .. "\n" ..
		[[			print("decorator", table.concat(a, ","), ...)]] .. "\n" ..
		[[			return f(...)]] .. "\n" ..
		[[		end]] .. "\n" ..
		[[	end]] .. "\n" ..
		[[}}]] .. "\n" ..
		[[]] .. "\n" ..
		[[function {}({})]] .. "\n" ..
		[[	print({}, {})]] .. "\n" ..
		[[	return setmetatable({{{}}}, mt)]] .. "\n" ..
		[[end]] .. "\n" ..
		[[]] .. "\n" ..
		[[-- Usage: e.g. random = dec() .. dec() .. function(n) math.random(n) end]],
		{
			i(1, "decorator_name"),
			i(2, "args"),
			rep(1),
			rep(2),
			rep(2),
		}
	)),
	s("for", fmt(
		[[for {1} in {2} do]] .. "\n" ..
		[[	{0}]] .. "\n" ..
		[[end]],
		{
			[0] = i(0),
			[1] = i(1),
			[2] = i(2), -- TODO choice pairs/ipairs/free
		}
	)),
	s({trig = "([%w_%.]+)%+%+", regTrig = true, wordTrig = false}, fmt(
		"{} = {} + 1",
		{ l(l.CAPTURE1, {}), l(l.CAPTURE1, {}) }
	)),
} , {
	s("fn", fmt(
		[[function {1} ({2})]] .. "\n" ..
		[[	{0}]] .. "\n" ..
		[[end]],
		{
			[0] = i(0),
			[1] = i(1),
			[2] = i(2),
		}
	),
	{
		condition = at_start_of_line,
	}),
	s({trig="lfn", hidden=false}, fmt(
		[[function {1} ({2})]] .. "\n" ..
		[[	{0}]] .. "\n" ..
		[[end]],
		{
			[0] = i(0),
			[1] = i(1),
			[2] = i(2),
		}
	),
	{
		condition = at_start_of_line,
	}),
}
