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
local types     = require("luasnip.util.types")
local util      = require("luasnip.util.util")
local node_util = require("luasnip.nodes.util")

-- don't expose the raw fmt to the outside
local fmt
do
	local tmp = require("luasnip.extras.fmt").fmt
	fmt = ls.extend_decorator.apply(tmp, {delimiters = "<>"})
end

local function at_start_of_line(line_to_cursor, matched_trigger,_)
	return line_to_cursor == matched_trigger
end

return {
	s("tex", fmt([[
	.PHONY: clean spellA spellT cont count

	MAIN  = main
	FILES = $(MAIN).tex Makefile

	AUX ?= tex-aux

	.PRECIOUS: $(MAIN).pdf

	$(MAIN).pdf: $(FILES) .cluttealtexrc.lua
		test -d $(AUX) || mkdir $(AUX)
		cluttealtex --output-directory=$(AUX) $(OPT) "$<<"

	define cfgfile
	return {
		options = {
			output_directory = "tex-aux",
			change_directory = true,
			engine = "lualatex",
			-- biber = true,
			-- glossaries = {
			-- 	-- {type="makeindex", out="gls", inp="glo", log="glg"},
			-- 	{type="makeindex", out="gls-abr", inp="glo-abr", log="glg-abr"},
			-- },
			max_iterations = "50",
			quiet = "0",
		},
		defaults = {
			watch = "inotifywait",
		},
		cli_options = {
			continuous = {
				long = "cont",
				handle_cli = function(options, _)
					options.watch = "inotifywait"
					options.memoize_opt = "readonly"
				end
			},
		},
	}
	endef
	export cfgfile
	.cluttealtexrc.lua:
		@echo "$$cfgfile" >> .cluttealtexrc.lua

	cont: $(FILES)
		touch "$(MAIN).tex"
		$(MAKE) OPT="--cont"

	count:
		texcount -col -inc $(MAIN).tex

	clean:
		-test -d $(AUX)  && $(RM) -r $(AUX)

	spellA: $(FILES)
		-aspell --home-dir=. --personal=dict.txt -l de_DE -t -c "$<<"
		iconv -f ISO-8859-1 -t UTF-8 ./dict.txt >> ./dict.txt2
	spellT: $(FILES)
		-textidote --check de --remove tikzpicture --replace replacements.txt --dict ./dict.txt2 --output html "$<<" >> $(MAIN)-texidote.html
		]], {}),
		{
			condition = at_start_of_line,
		}),
},{}
