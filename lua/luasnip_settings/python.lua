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

local function py_init()
  return
    sn(nil, c(1, {
      t(""),
      sn(1, {
        t(", "),
        i(1),
        d(2, py_init)
      })
    }))
end

local function to_init_assign(args)
	local tab = {}
	local a = args[1][1]
	if #(a) == 0 then
		table.insert(tab, t({"", "\tpass"}))
	else
		local cnt = 1
		for e in string.gmatch(a, " ?([^,]*) ?") do
			if #e > 0 then
				table.insert(tab, t({"","\tself."}))
				table.insert(tab, r(cnt, tostring(cnt), i(nil,e)))
				table.insert(tab, t(" = "))
				table.insert(tab, t(e))
				cnt = cnt+1
			end
		end
	end
	return
		sn(nil, tab)
end

return {
	s("__init", fmt(
		[[def __init__(self{args}):{init}]],
		{
			args = d(1, py_init),
			init = d(2, to_init_assign, {1}),
		})),
	s("getter/setter", fmt(
		[[
		@property
			def {}(self):
				return self._{}
			@{}.setter
			def $1(self, {}):
				if isinstance({}, {}):
					self._{} = {}
				else:
					raise AttributeError("{} has to be a {}, but was", type({}))]],
		{
			i(1,"attr"),
			rep(1),
			rep(1),
			rep(1),
			rep(1), i(2,"type"),
			rep(1), rep(1),
			rep(1), i(2,"type"), rep(1),
		})),
	s("plt", fmt(
		[[
		import mplcatppuccin
		import matplotlib as mpl
		import matplotlib.pyplot as plt

		mpl.style.use("mocha")
		plt.plot([0,1,2,3], [1,2,3,4])
		plt.show()
		]],
		{}
	))
} , {
	s("#!", fmt(
		[[
		#!/bin/python3
		{}]],
		{
			i(0),
		}),
		{
			condition = at_start_of_line,
		}),
	s("main", fmt(
		[[
		if __name__ == "__main__":
			{0}]],
		{
			[0] = i(0),
		}),
		{
			condition = at_start_of_line,
		}),
	s("def", fmt(
		[[
		def {1}({2}):
			{0}]],
		{
			[0] = i(0),
			[1] = i(1),
			[2] = i(2),
		}),{
			condition = at_start_of_line,
		}),
}
