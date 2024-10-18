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

local function max_len(...)
	local r = 0
	for _,a in ipairs{...} do
		for _,v in ipairs(a) do
			r = math.max(r, #v)
		end
	end
	return r
end

local function gen_entry(name, opts)
	local required,optional = opts.required, opts.optional
	local p = max_len(required, optional)
	local r_s = {string.format("@%s{{{key},", name)}
	local idx = 1
	local r_n = {key = i(idx)} idx=idx+1

	for _,r in ipairs(required) do
		table.insert(r_s, string.format('%'..p..'s = {{{%s}}},', r,r))
		r_n[r] = i(idx) idx=idx+1
	end
	for _,o in ipairs(optional) do
		table.insert(r_s, string.format('{%s},', o))
		r_n[o] = c(idx, {
			sn(nil, fmt(string.format('%%%'..p..'s = {{{%s}}}', o,o),
				{[o] = i(1)},
				{trim_empty=false, dedent=false}
			)),
			sn(nil, fmt(string.format('%'..p..'s = {{{%s}}}', o,o),
				{[o] = i(1)},
				{trim_empty=false, dedent=false}
			)),
		})
		idx=idx+1
	end
	table.insert(r_s, "}}")

	return fmt(table.concat(r_s, "\n"), r_n, {trim_empty=false, dedent=false})
end

return {
	-- no autotrigger
}, {
	-- autotrigger
	s("article", fmt(
	[[@article{{{key},]] .. "\n" ..
	[[	author  = {{{author}}},]] .. "\n" ..
	[[	title   = {{{title}}},]] .. "\n" ..
	[[	journal = {{{journal}}},]] .. "\n" ..
	[[	year    = {year},]] .. "\n" ..
	[[	volume  = {{{volume}}},]] .. "\n" ..
	[[	number  = {{{number}}},]] .. "\n" ..
	[[{pages}]] .. "\n" ..
	[[}}]],
		{
			key     = i(1),
			author  = i(2),
			title   = i(3),
			journal = i(4),
			year    = i(5),
			volume  = i(6),
			number  = i(7),
			pages   = c(8, {
				sn(nil, fmt(
					[[	pages = {pages},]],
					{
						pages = i(1),
					}
				)),
				sn(nil, fmt(
					[[	% pages = pages,]],
					{
						-- pages = i(1),
					}
				)),
			}),
		}
	),
	{
		condition = at_start_of_line,
	}),
	s("article", gen_entry("article", {
		required={"author", "title", "journaltitle", "year", "date"},
		optional={
			"translator", "annotator", "commentator", "subtitle",
			"titleaddon", "editor", "editora", "editorb", "editorc",
			"journalsubtitle", "journaltitleaddon", "issuetitle", "issuesubtitle",
			"issuetitleaddon", "language", "origlanguage", "series", "volume",
			"number", "eid", "issue", "month", "pages", "version", "note", "issn",
			"addendum", "pubstate", "doi", "eprint", "eprintclass", "eprinttype",
			"url", "urldate",
		},
	})),
	s("book", gen_entry("book", {
		required={"author","title","year","date"},
		optional={
			"editor", "editora", "editorb", "editorc", "translator, ",
			"annotator", "commentator", "introduction", "foreword", "afterword, ",
			"subtitle", "titleaddon", "maintitle", "mainsubtitle",
			"maintitleaddon", "language", "origlanguage", "volume", "part",
			"edition", "volumes", "series", "number", "note", "publisher",
			"location", "isbn", "eid", "chapter", "pages", "pagetotal",
			"addendum", "pubstate", "doi", "eprint", "eprintclass, ",
			"eprinttype", "url", "urldate",
		},
	})),
	s("online", gen_entry("online", {
		required={"author", "editor", "title", "year", "date", "doi", "eprint", "url"},
		optional={
			"subtitle", "titleaddon", "language", "version", "note",
			"organization", "month", "addendum", "pubstate", "eprintclass",
			"eprinttype", "urldate",
		},
	})),
	s("proceedings", gen_entry("proceedings", {
		required={"title", "year", "date"},
		optional={
			"editor", "subtitle", "titleaddon", "maintitle", "mainsubtitle",
			"maintitleaddon", "eventtitle", "eventtitleaddon", "eventdate",
			"venue", "language", "volume", "part", "volumes", "series",
			"number", "note", "organization", "publisher", "location", "month",
			"isbn", "eid", "chapter", "pages", "pagetotal", "addendum",
			"pubstate", "doi", "eprint", "eprintclass", "eprinttype", "url",
			"urldate",
		},
	})),
	s("inproceedings", gen_entry("inproceedings", {
		required={"author", "title", "booktitle", "year","date"},
		optional={
			"editor", "subtitle", "titleaddon", "maintitle", "mainsubtitle",
			"maintitleaddon", "booksubtitle", "booktitleaddon", "eventtitle",
			"eventtitleaddon", "eventdate", "venue", "language", "volume",
			"part", "volumes", "series", "number", "note", "organization",
			"publisher", "location", "month", "isbn", "eid", "chapter",
			"pages", "addendum", "pubstate", "doi", "eprint", "eprintclass",
			"eprinttype", "url", "urldate",
		},
	}))
}
