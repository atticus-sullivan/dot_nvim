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

return {
	s("proof structural induction", fmt(
		[[Proof by induction on {} {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[Case {}]] .. "\n" ..
		[[	To show: {} .=. {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[	Proof]] .. "\n" ..
		[[				{}]] .. "\n" ..
		[[		(by {}) .=. {}]] .. "\n" ..
		[[	QED]] .. "\n" ..
		[[]] .. "\n" ..
		[[Case {}]] .. "\n" ..
		[[	To show: {} .=. {}]] .. "\n" ..
		[[		IH: {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[		Proof]] .. "\n" ..
		[[					{}]] .. "\n" ..
		[[			(by {}) .=. {}]] .. "\n" ..
		[[		QED]] .. "\n" ..
		[[{}]] .. "\n" ..
		[[QED]],
		{
			i(1, "type"),
			i(2, "variable name"),
			i(3, "base case"),
			i(4, "lemma for base left"),
			i(5, "lemma for base right"),
			rep(4),
			i(6, "rule"),
			i(7, "proof"),
			i(8, "2nd case"),
			i(9, "lemma for case left"),
			i(10, "lemma for case right"),
			i(11, "induction hyp"),
			rep(9),
			i(12, "rule"),
			i(13, "proof"),
			i(0),
		})),
	s("proof case induction", fmt(
		[[Case {}]] .. "\n" ..
		[[	To show: {} .=. {}]] .. "\n" ..
		[[		IH: {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[		Proof]] .. "\n" ..
		[[					{}]] .. "\n" ..
		[[			(by {}) .=. {}]] .. "\n" ..
		[[		QED]],
		{
			i(1, "case"),
			i(2, "lemma for case left"),
			i(3, "lemma for case right"),
			i(4, "induction hyp"),
			rep(2),
			i(5, "rule"),
			i(6, "proof"),
		})),
	s("proof computational induction", fmt(
		[[Proof by computation induction on {} with {}]] .. "\n" ..
		[[Case 1]] .. "\n" ..
		[[	To show: {} .=. {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[	Proof]] .. "\n" ..
		[[				{}]] .. "\n" ..
		[[		(by {}) .=. {}]] .. "\n" ..
		[[	QED]] .. "\n" ..
		[[]] .. "\n" ..
		[[Case 2]] .. "\n" ..
		[[	To show: {} .=. {}]] .. "\n" ..
		[[		IH: {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[		Proof]] .. "\n" ..
		[[					{}]] .. "\n" ..
		[[			(by {}) .=. {}]] .. "\n" ..
		[[		QED]] .. "\n" ..
		[[{}]] .. "\n" ..
		[[QED]],
		{
			i(1, "variables"),
			i(2, "function name"),
			i(3, "lemma for recursion base left"),
			i(4, "lemma for recursion base right"),
			rep(3),
			i(5, "rule"),
			i(6, "proof"),
			i(7, "lemma for next equation left"),
			i(8, "lemma for next equation right"),
			i(9, "induction hyp"),
			rep(7),
			i(10, "rule"),
			i(11, "proof"),
			i(0),
		})),
	s("proof equality", fmt(
		[[Proof]] .. "\n" ..
		[[					{}]] .. "\n" ..
		[[	(by {}) .=. {}]] .. "\n" ..
		[[QED]],
		{
			i(1),
			i(2, "rule"),
			i(3, "proof"),
		})),
	s("proof case analysis", fmt(
		[[Proof by case analysis on {} {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[Case {}]] .. "\n" ..
		[[	Assumption: {} .=. {}]] .. "\n" ..
		[[]] .. "\n" ..
		[[	Proof]] .. "\n" ..
		[[		{}]] .. "\n" ..
		[[	QED]] .. "\n" ..
		[[]] .. "\n" ..
		[[Case {}]] .. "\n" ..
		[[	{}]] .. "\n" ..
		[[]] .. "\n" ..
		[[QED]],
		{
			i(1, "data type"),
			i(2, "variable name"),
			i(3, "constructor"),
			i(4, "variable name"),
			rep(3),
			i(5, "proof"),
			i(6, "constructor"),
			i(7, "proof"),
		})),
	s("proof lemma", fmt(
		[[Lemma {}: {} .=. {}]] .. "\n" ..
		[[Proof {}]] .. "\n" ..
		[[QED]],
		{
			i(1, "name-optional"),
			i(2, "left side"),
			i(3, "right side"),
			i(0, "type/proof"),
		})),
}
