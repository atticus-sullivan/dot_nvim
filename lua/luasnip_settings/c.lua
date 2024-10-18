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
		s("print array", fmt(
			[[printf("Array: ");]] .. "\n" ..
			[[for (unsigned long index=0; index<{}; index++)]] .. "\n" ..
			[[	printf(index<({}-1)?"%d ":"%d", {}[index]);]],
			{
				i(1, "size"),
				rep(1),
				i(2, "array"),
			})),
		s("printf", fmt(
			[[printf("{}{}", {});]],
			{
				i(1, "fmt"),
				i(2, "\\n"),
				i(3, "args"),
			})),
		s("default_file_description", fmt(
			[[/* ]] .. "\n" ..
			[[ * ---------------------------------------------------------]] .. "\n" ..
			[[ * Filename: {}]] .. "\n" ..
			[[ * Author: {}]] .. "\n" ..
			[[ * Last changes: {}]] .. "\n" ..
			[[ * Version: {}]] .. "\n" ..
			[[ * Usage: ]] .. "\n" ..
			[[ *     {}]] .. "\n" ..
			[[ * ---------------------------------------------------------]] .. "\n" ..
			[[ */]],
			{
				i(1, "filename"),
				i(2, "author"),
				i(3, "last changes"),
				i(4, "version"),
				i(5, "usage"),
			})),
		s("function description", fmt(
			[[/*]] .. "\n" ..
			[[ * Usage:]] .. "\n" ..
			[[ *	{}]] .. "\n" ..
			[[ *  ]] .. "\n" ..
			[[ * Parameters:]] .. "\n" ..
			[[ *	{}]] .. "\n" ..
			[[ *]] .. "\n" ..
			[[ * Return values:]] .. "\n" ..
			[[ *	{}]] .. "\n" ..
			[[ */]],
			{
				i(1, "usage description"),
				i(2, "enumerate all parameters with short description"),
				i(3, "possible retun values"),
			})),
		-- TODO see for(%w+) of cpp
		s("fori", fmt(
			[[for(int {}=0; {} < {}; {}++){{]] .. "\n" ..
			[[	{}]] .. "\n" ..
			[[}}]],
			{
				i(1, "i"),
				rep(1),
				i(2),
				rep(1),
				i(0),
			})),
		s("dec compare qsort", fmt(
			[[int compare(const void * a, const void * b);]],
			{})),
		s("init_compare", fmt(
			[[int compare(const void * a, const void * b) {{]] .. "\n" ..
			[[]] .. "\n" ..
			[[	if (* ({} *) a < * ({} *) b)]] .. "\n" ..
			[[		return -1;]] .. "\n" ..
			[[]] .. "\n" ..
			[[	else if (* ({} *) a == * ({} *) b)]] .. "\n" ..
			[[		return 0;]] .. "\n" ..
			[[]] .. "\n" ..
			[[	else]] .. "\n" ..
			[[		return 1;]] .. "\n" ..
			[[}}]],
			{
				i(1, "type-compare"),
				rep(1),
				rep(1),
				rep(1),
			})),
		s("rb tree template", fmt(
			[[struct {} {{]] .. "\n" ..
			[[	{}; // key]] .. "\n" ..
			[[	{}]] .. "\n" ..
			[[	RB_ENTRY({}) link;]] .. "\n" ..
			[[}};]] .. "\n" ..
			[[int {}(struct {} *a, struct {} *b){{]] .. "\n" ..
			[[	return (a->{} < b->{} ? -1 : a->{} > b->{});]] .. "\n" ..
			[[}}]] .. "\n" ..
			[[RB_HEAD({}, {});]] .. "\n" ..
			[[RB_PROTOTYPE({}, {}, link, {})]] .. "\n" ..
			[[RB_GENERATE({}, {}, link, {})]],
			{
				i(1, "element tree"),
				i(4, "type and name of the key"),
				i(5, "additional values"),
				rep(1),
				i(2, "cmp"), rep(1), rep(1),
				f(function(args,_,_) return args[1][1]:gsub(".* (.*)", "%1") end, {4}), -- insert the name of the key field
				f(function(args,_,_) return args[1][1]:gsub(".* (.*)", "%1") end, {4}), -- insert the name of the key field
				f(function(args,_,_) return args[1][1]:gsub(".* (.*)", "%1") end, {4}), -- insert the name of the key field
				f(function(args,_,_) return args[1][1]:gsub(".* (.*)", "%1") end, {4}), -- insert the name of the key field
				i(3, "head struct name"), rep(1),
				rep(3), rep(1), rep(2),
				rep(3), rep(1), rep(2),
			})),
		s("list", fmt(
			[[struct {} {{]] .. "\n" ..
			[[	{}]] .. "\n" ..
			[[	SLIST_ENTRY({}) link;]] .. "\n" ..
			[[}};]] .. "\n" ..
			[[SLIST_HEAD({}, {});]],
			{
				i(1, "element alt"),
				i(3, "values"),
				rep(1),
				i(2, "head struct name"), rep(1),
			}),
			{
			}),
} , {
		s("AoC", fmt(
			[[#include <stdio.h>]] .. "\n" ..
			[[#include <stdlib.h>]] .. "\n" ..
			[[#include <string.h>]] .. "\n" ..
			[[]] .. "\n" ..
			[[#include "./read_file.h"]] .. "\n" ..
			[[]] .. "\n" ..
			[[int part1(struct string_content* input){{]] .. "\n" ..
			[[	{}]] .. "\n" ..
			[[	return 0;]] .. "\n" ..
			[[}}]] .. "\n" ..
			[[]] .. "\n" ..
			[[int part2(struct string_content* input){{]] .. "\n" ..
			[[	return 0;]] .. "\n" ..
			[[}}]] .. "\n" ..
			[[]] .. "\n" ..
			[[int main() {{]] .. "\n" ..
			[[	char* type;]] .. "\n" ..
			[[	(void)type;]] .. "\n" ..
			[[]] .. "\n" ..
			[[	struct string_content *input;]] .. "\n" ..
			[[	input = read_file("./day-{}.dat.testing", type);]] .. "\n" ..
			[[	printf("Part1:\n%d\n", part1(input));]] .. "\n" ..
			[[	free_file(input);]] .. "\n" ..
			[[	]] .. "\n" ..
			[[	input = read_file("./day-{}.dat.testing", type);]] .. "\n" ..
			[[	printf("\nPart2:\n%d\n", part2(input));]] .. "\n" ..
			[[	free_file(input);]] .. "\n" ..
			[[	return EXIT_SUCCESS;]] .. "\n" ..
			[[}}]],
			{
				i(0),
				i(1),
				rep(1),
			}),
			{
				condition = at_start_of_line,
			}),
		s("inc", fmt(
			[[#include {}]],
			{
				i(1, "lib"),
			}),
			{
				condition = at_start_of_line,
			}),
		s("default", fmt(
			[[#include <limits.h>]] .. "\n" ..
			[[#include <stdio.h>]] .. "\n" ..
			[[#include <stdlib.h>]] .. "\n" ..
			[[#include <string.h>]] .. "\n" ..
			[[]] .. "\n" ..
			[[int main(int argc, char** argv) {{]] .. "\n" ..
			[[	{}]] .. "\n" ..
			[[	return EXIT_SUCCESS;]] .. "\n" ..
			[[}}]],
			{
				i(i),
			}),
			{
				condition = at_start_of_line,
			}),
}
