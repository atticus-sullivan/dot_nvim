local ls        = require"luasnip"
local s         = ls.snippet
-- local sn        = ls.snippet_node
-- local isn       = ls.indent_snippet_node
local t         = ls.text_node
local i         = ls.insert_node
-- local f         = ls.function_node
local c         = ls.choice_node
-- local d         = ls.dynamic_node
-- local r         = ls.restore_node
-- local events    = require("luasnip.util.events")
-- local ai        = require("luasnip.nodes.absolute_indexer")
-- local rep       = require("luasnip.extras").rep
local fmt       = require("luasnip.extras.fmt").fmt
-- local types     = require("luasnip.util.types")
-- local util      = require("luasnip.util.util")
-- local node_util = require("luasnip.nodes.util")

return {
	s("repeat", fmt(
		[[\repeat {t} {num} {{{music}}}]],
		{
			t     = c(1, {t("volta"), t("unfold"), t("percent")}),
			num   = i(2, "3"),
			music = i(3, "music"),
	})),
	s({name="concurrent drums", trig="<<<", snippetType="autosnippet"}, fmt(
		[[
		<<
			{{{voice1}}}
			\\
			{{{voice2}}}
		>>]],
		{
			voice1 = i(1),
			voice2 = i(2),
	})),
	s("sec", fmt(
		[[
		\section
		\sectionLabel "{label}"]],
		{
			label = i(1),
	})),
	s("triole", fmt(
		[[
		\tuplet 3/2 {{{}}}
		]],
		{
		[1] = i(1),
	})),
	s("flam", fmt(
		[[
		\acciaccatura {{{pre}}} {note}
		]],
		{
		pre  = i(1, "sn16"),
		note = i(2, "sn16"),
	})),
	s("repeatAccent", fmt(
		[[
		\after {pos} {{
			\once \override BalloonText.annotation-balloon = ##f
			\once \override BalloonText.annotation-line    = ##f
			\once \override BalloonText.text-alignment-X  = -1
			\balloonGrobText BarLine #'(0.1 . 1.5) \markup {{ \musicglyph #"scripts.sforzato" }}
		}}
		]],
		{
			pos = i(1, "1*4"),
	})),
	s("voltaA", fmt(
		[[
		\repeat volta {num} {{
			{musicA}
			\alternative {{
				\volta 1 {{{musicB}}}
			}}
		}}
		]],
		{
			num = i(1, "2"),
			musicA = i(2, "music"),
			musicB = i(3, "music"),
	})),
}
