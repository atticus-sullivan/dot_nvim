local ls             = require"luasnip"
local s              = ls.snippet
local sn             = ls.snippet_node
local isn            = ls.indent_snippet_node
local t              = ls.text_node
local i              = ls.insert_node
local f              = ls.function_node
local c              = ls.choice_node
local d              = ls.dynamic_node
-- local r              = ls.restore_node
local rep            = require("luasnip.extras").rep
-- local types          = require("luasnip.util.types")
-- local util           = require("luasnip.util.util")
-- local node_util      = require("luasnip.nodes.util")
local expand_cond    = require("luasnip.extras.conditions.expand")
local make_condition = require("luasnip.extras.conditions").make_condition

local function visual_selection(_, parent)
    return parent.snippet.env.TM_SELECTED_TEXT or {}
end

-- don't expose the raw fmt to the outside
local fmt
do
	local tmp = require("luasnip.extras.fmt").fmt
	fmt = ls.extend_decorator.apply(tmp, {delimiters = "<>"})
end

--------------------
-- ADD CONDITIONS --
--------------------
-- always check if this field is already defined
-- assert(not expand_cond.in_mathzone, "already defined")
-- expand_cond.in_mathzone = make_condition(function()
-- 	-- return vim.fn['vimtex#syntax#in_mathzone']() == 1
-- 	return true
-- end)
-- assert(not expand_cond.beamer, "already defined")
expand_cond.beamer      = make_condition(function() return vim.b.vimtex["documentclass"] == "beamer" end)
-- assert(not expand_cond.in_env, "already defined")
expand_cond.in_env      = function(env)
	return make_condition(function()
		local is_inside = vim.fn['vimtex#env#is_inside'](env)
		return (is_inside[1] > 0 and is_inside[2] > 0)
	end)
end
-- assert(not expand_cond.in_tikz, "already defined")
expand_cond.in_tikz = expand_cond.in_env("tikzpicture")

-------------
-- HELPERS --
-------------
local function gen_text_and_math_snip(math, trigger, expansion, name)
	return
	s({trig=trigger, name=name, wordTrig=false}, t(expansion), {
	})
	-- if math then
	-- 	return
	-- 	s({trig=trigger, name=name}, t(expansion), {
	-- 		condition      = expand_cond.in_mathzone,
	-- 		show_condition = expand_cond.in_mathzone,
	-- 	})
	-- else
	-- 	return
	-- 	s({trig=trigger, name=name}, t("$"..expansion.."$"), {
	-- 		condition      = -expand_cond.in_mathzone,
	-- 		show_condition = -expand_cond.in_mathzone,
	-- 	})
	-- end
end
local function gen_env_node(env)
	return fmt(
	[[
	\begin{<env1>}
		<0>
	\end{<env2>}
	]],
	{
		env1 = i(1, env),
		env2 = rep(1),
		[0]  = i(0),
	})
end
local plain = {
	"",
	{
		[[\usepackage[utf8]{inputenc}                   % encoding of the inputfile]],
		[[\usepackage[T1]{fontenc}                      % Westeuropean charset]],
		[[\usepackage{lmodern}                          % more modern font]],
	},
}
local lua = {
	{[[ \usepackage{fontspec} % LuaLaTeX]], ""},
	""
}
local function plain_or_lua(args,_ , uarg1)
	if args[1] == "%!TeX program = lualatex" then
		return lua[uarg1]
	elseif args[1] == "%!TeX program = pdflatex" then
		return plain[uarg1]
	else
		return ""
	end
end
local function itemI(args)
	if args[1][1] == "enumerate" then
		return sn(nil, {
			t({"", "\t"}),
			c(1, {
				t([[\renewcommand{\theenumi}{\arabic{enumi}}]]),
				t([[\renewcommand{\theenumi}{\Alph{enumi}}]]),
				t([[\renewcommand{\theenumi}{\alph{enumi}}]]),
				t([[\renewcommand{\theenumi}{\Roman{enumi}}]]),
				t([[\renewcommand{\theenumi}{\roman{enumi}}]]),
			}),
		})
	else
		return sn(nil, {t("")})
	end
end


--------------
-- SNIPPETS --
--------------
local snip_gen = {}

function snip_gen.default_preamble(snipps)
	table.insert(snipps, s({trig="default article"}, fmt(
	[[<XeLua_or_plain>
	\documentclass[a4paper, 12pt]{scrartcl}

	<plain_lua_I>
	% ----- Packages -----
	\usepackage{xspace}
	\newcommand{\zB}{z.\,B.\xspace}
	\usepackage{scrlayer-scrpage}                 % header and footer
	\usepackage[ngerman]{babel}                   % translate fixed strings and load german hyphenation
	<plain_lua_II>
	\usepackage{microtype}
	\usepackage{fontspec}
	\usepackage{zref-clever}
	\usepackage[<hyperef_col>breaklinks=true]{hyperref}       % make e.g. toc clickable
	% \usepackage{showframe}                      % show page boundaries to check if lines are too long
	\usepackage[german=quotes]{csquotes}      % pick always the right quotation marks

	% \usepackage{multicol} % use \begin{multicols}{num} text \end{multicols} and the text will be automatically distributed

	\usepackage{todo}               % to enter todos in the document
	% \usepackage{subcaption}       % for subfigures

	% \usepackage[ngerman]{isodate} % localized date formatting

	\usepackage{graphicx}         % include graphics
	\usepackage{tabularx}         % better configuration of tables
	\usepackage{ltxtable}         % use tabularx as longtable (\LTXtable{width}{pathToTable}) where the table referenced to contains of \begin{longtable}{preamble}content\end{longtable}
	\usepackage{booktabs}         % more nice rules (headrule/midrule/crule/bottomrule)

	\usepackage{xcolor}

	% \usepackage{pifont} % special characters (insert via \ding{num})

	% ----- Settings -----
	\KOMAoptions{
		paper=a4,           % set papersize
		fontsize=12pt,      % set fontsize to 12pt
		parskip=half,       % half a line will seperate paragraphs
		headings=normal,    % headings in normalsize
		BCOR=0cm,           % no space for binding
		DIV=calc,           % calculare margins automatically, the calculated values can be found in the log file or use \areaset[BCOR]{width}{height}} to explicitly specify the textarea
		twoside=false,      % onesided document
		twocolumn=false,    % one columned pages
		draft=false,         % show additional information
		numbers=autoendperiod, % automatic punctuation in outline
	}

	% \parskip5pt
	% \parindent0pt

	<2>
	\begin{document}
	<0>
	\todos
	\end{document}
	]], {
		["hyperef_col"] = i(2, "colorlinks=false,"),
		[2] = i(2),
		[0] = i(0),
		["XeLua_or_plain"] = c(1, {t("%!TeX program = lualatex"), t("%!TeX program = pdflatex")}),
		["plain_lua_I"] = f(plain_or_lua, {1}, {userargs={1}}),
		["plain_lua_II"] = f(plain_or_lua, {1}, {userargs={2}}),
	}
	))
	)

	table.insert(snipps, s({trig="default beamer"}, fmt(
	[[
	%!TeX program = lualatex

	\documentclass[ignorenonframetext,aspectratio=169,hyperref={<hyperref_col>breaklinks=true}]{beamer} % pass handout option to create a handout and \usepackage{pgfpages} \pgfpagesuselayout{4 on 1}[a4paper,border shrink=5mm]
	% documentclass may be (article,book,...) too, load then the package beamerarticle (with \cmd<<presentation>> a command may be only printed in the presentation mode)
	% use ignorenoframetext on beamer class to ignore text outside of frames (will be shown in article version)
	% \\ will be ignored in article mode when being inside a frame, use \\<<all>> to override
	% option: aspectratio=169 for 16:9 format (149,141,54,43 and 32 possible too)

	\mode<<presentation>>{ % is only processed when mode is presentation (not handout or article)
		\setbeamertemplate{blocks}[rounded][shadow=true]
		\setbeamertemplate{items}[circle]
		\setbeamertemplate{sections/subsections in toc}[circle]
		\setbeamertemplate{title page}[default][colsep=-4bp,rounded=true,shadow=true]
		\setbeamertemplate{part page}[default][colsep=-4bp,rounded=true,shadow=true]
		\setbeamertemplate{section page}[default][colsep=-4bp,rounded=true,shadow=true]
		\setbeamertemplate{subsection page}[default][colsep=-4bp,rounded=true,shadow=true]

		\useoutertheme{infolines}

		\setbeamerfont{block title}{size={}}
		\setbeamercolor{titlelike}{parent=structure,bg=white}

		\usecolortheme[style=Latte]{catppuccin}
		% \setbeamertemplate{footline} % To remove the footer line in all slides uncomment this line
		% \setbeamertemplate{footline}[page number] % To replace the footer line in all slides with a simple slide count uncomment this line
	}

	\usepackage{fontspec} %

	% ----- Packages -----
	\usepackage{xspace}
	\newcommand{\zB}{z.\,B.\xspace}
	\usepackage[ngerman]{babel}                   % translate fixed strings and load german hyphenation
	% \usepackage{showframe}                      % show page boundaries to check if lines are too long
	\usepackage[german=quotes]{csquotes}      % pick always the right quotati

	\usepackage{todo}               % to enter todos in the document
	% \usepackage{subcaption}       % for subcaption

	% \usepackage[ngerman]{isodate} % localized date

	\usepackage{graphicx}         % include graphics
	\usepackage{tabularx}         % better configuration of tables
	\usepackage{ltxtable}         % use tabularx as longtable (\LTXtable{width}{pathToTable}) where the table referenced to contains of \begin{longtable}{preamble}content\end{longtable}
	\usepackage{booktabs}         % more nice rules (headrule/midrule/crule/bot

	\usepackage{xcolor}

	% \usepackage{pifont} % special characters (insert via \ding)

	\title<short-title>{<title>}
	% \subtitle[short]{subtitle}
	% \subject{text} % only for pdf doc information
	\author{<author>}
	% \institute[short on bottom of each slide]{insitute for title}
	\date

	% Overlays:
	% \pause[slideNo] ->> display everything until here, next slide show next "segment" in addition
	% \only<<OS>>{code} ->> only set code on slides mentioned with the OS (no space is occupied)
	% \onslide<<OS>>{code}  ->> text is uncovered only on given slides ->> uncover
	% \onslide+<<OS>>{code} ->> text is uncovered only on given slides (occupies space on other slides) ->> visible
	% \onslide*<<OS>>{code} ->> text is uncovered only on given slides ->> only
	% \uncover<<OS>>{code}  ->> only present on given slides, on other occupies space, text is shown as transparent (use \setbeamercovered{transparent[=opaq]} to activate transp)
	% \visible<<OS>>{code}  ->> only present on given slides, on other occupies space, text is not shown as transparent
	% \invisible<<OS>>{code} ->> opposite of visible
	% \alt<<OS>>{def}{alt}   ->> on given slides def is shown, on others alt is shown
	% \temporal<<OS>>{bef}{def}{after} ->> like alt, but the alternative depends whether it is the slides before or after the given ones
	% overlay-specifications (OS) are given in <<a-b>>,(comma seperated list is possble to)
	%   then the command will only have an effect on these slides (a/b might be omitted), they might be used on many different commands
	%   use <<+->> to increment by one (<<1->> <<2->> <<3->> ...)
	%  itemize-env allows to specify a default over

	\begin{document}
	\begin{frame}
	\titlepage
	\end{frame}


	\begin{frame}
	\frametitle{Overview}
	\tableofcontents
	\end{frame}


	\begin{frame}
	<0>
	\end{frame}
	% \todos
	\end{document}
	]], {
		["hyperref_col"] = i(1, "colorlinks=false,"),
		["short-title"]  = i(2, "[short-title]"),
		["title"]        = i(3),
		["author"]       = i(4),
		[0]              = i(0),
	}))
	)

	table.insert(snipps, s({trig="default algorithm", name="load default algorithm settings"}, fmt(
	[[
	\usepackage[linesnumbered,vline,ruled,titlenotnumbered]{algorithm2e}  % for pseudocode

	\SetKwProg{Fn}{Function}{:}{}
	\DontPrintSemicolon
	\SetAlFnt{\footnotesize\ttfamily}
	\SetAlCapFnt{\small\ttfamily}
	\SetAlCapNameFnt{\small\ttfamily}
	\newcommand\mycommfont[1]{\footnotesize\ttfamily\textcolor{gray}{#1}}
	\SetCommentstyle{mycommfont}
	\SetKwRepeat{DoWhile}{do}{while}]],
	{
	}))
	)

	-- TODO rework the styling
	table.insert(snipps, s({trig="default listings", name="load default listings settings"}, fmt(
	[[
	\usepackage{listings} % for code

	\definecolor{myorange}{rgb}{1.0,0.4,0}
	\definecolor{mygray}{rgb}{0.4,0.4,0.4}
	\definecolor{keywordGreen}{RGB}{0,128,0}
	\definecolor{lightgray}{rgb}{0.9,0.9,0.9}
	\lstset{
		rulecolor=\color{black},
		emphstyle=\color{blue},
		basicstyle=\scriptsize\sffamily,
		stringstyle=\color{myorange},
		commentstyle=\color{mygray},
		keywordstyle=\color{keywordGreen},
		%
		backgroundcolor=\color{lightgray},
		frame=none,
		%
		numbers=left,
		numbersep=10pt,
		numberstyle=\tiny,
		%
		xleftmargin=2em,
		framexleftmargin=2em,
		%
		columns=fullflexible, % columns of chars
		tabsize=4,
		%
		captionpos=b,
		%
		gobble=4,             % ignore the first 4 characters
		breakautoindent=true, %
		postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
		breaklines=true,
		%
		showstringspaces={<stringspaces>},
		showtabs=<tabs>,
		showspaces=<spaces>,
		keepspaces=true,
		%
		inputencoding=utf8, extendedchars=true,
		literate=
		{á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
		{Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
		{à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
		{À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\`I}}1 {Ò}{{\`O}}1 {Ù}{{\`U}}1
		{ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
		{Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\"I}}1 {Ö}{{\"O}}1 {Ü}{{\"U}}1
		{â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
		{Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\^U}}1
		{Ã}{{\~A}}1 {ã}{{\~a}}1 {Õ}{{\~O}}1 {õ}{{\~o}}1
		{œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
		{ű}{{\H{u}}}1 {Ű}{{\H{U}}}1 {ő}{{\H{o}}}1 {Ő}{{\H{O}}}1
		{ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
		{€}{{\euro}}1 {£}{{\pounds}}1 {«}{{\guillemotleft}}1
		{»}{{\guillemotright}}1 {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {¿}{{?`}}1
	}]], {
		stringspaces = i(1, "true"),
		tabs         = rep(1),
		spaces       = rep(1),
	}))
	)

	table.insert(snipps, s({trig="default hyperref metatada"}, fmt(
	[[
	\hypersetup{
		pdfauthor={<author>},
		pdftitle={<title>},
		pdfsubject={<subject>},
		pdfkeywords={<key>}
	}
	]], {
			author  = i(1),
			title   = i(2),
			subject = i(3),
			key     = i(4),
		}))
	)

	table.insert(snipps, s({trig="default math"}, fmt(
	[[
	% \usepackage{nicematrix}       % easy configurable array/matrix environments
	% \usepackage{amsmath, amssymb} % mathematical Symbols
	% \usepackage{mathtools}        % Text under equation
	% \usepackage{cancel}           % strikeout text
	% \usepackage{physics}          % don't know
	% \usepackage{siunitx}          % simpler variables
	% \usepackage{textcomp}         % For arrow
	% \setlength\mathindent{0cm}    % indentation of formulars
	% \openup 0.5\jot               % set linespacing in mathmode (does not affect spacing in normal mode)
	]], {}))
	)

	table.insert(snipps, s({trig="default tikz"}, fmt(
	[[
	% \usepackage{tikz}
	% \usetikzlibrary{calc,positioning,fit}  % calc for $...$ calculations, positioning for .west .south positioning
	% \usepackage{pgfplots}                  % draw diagrams
	% \usepackage{pgfkeys}                   % nice key management
	]], {}))
	)
end

function snip_gen.ordinary(snipps)
	table.insert(snipps,
		s({trig="...", name="ldots", snippetType="autosnippet"}, t([[\ldots]]))
	)

	table.insert(snipps, s({trig="beg", name="begin{} / end{}"}, fmt(
	[[\begin{<1>}]] .. "\n" ..
	[[	<0>]] .. "\n" ..
	[[\end{<2>}]], {
		[1] = i(1),
		[0] = i(0),
		[2] = rep(1),
	}), {condition = expand_cond.line_begin})
	)

	table.insert(snipps, s({trig="mmp", name="minipage"}, fmt(
	[[
	\begin{minipage}{<width>}<stop><last>
	\end{minipage}]], {
		width = c(1, {
			sn(nil, {t("0."), i(1, "49"), t[[\linewidth]]}),
			i(nil)
		}),
		stop = isn(nil, {f(function(_,parent)
				if parent.snippet.env.TM_SELECTED_TEXT then
					local ret = parent.snippet.env.TM_SELECTED_TEXT
					table.insert(ret, 1, "")
					return ret
				else
					return {}
				end
			end)}, "$PARENT_INDENT\t"),
		last = i(0),
	}))
	)

	table.insert(snipps, s({trig="txt", name="\\text{}"}, {t"\\text{", i(1), t"}"})
	)

	table.insert(snipps, s({trig="ref", name="\\autoref{}"}, {t"\\autoref{", i(1), t"}"})
	)
end

function snip_gen.math(snipps)
	for _,e in ipairs{
		{"<=",    "leq",             "\\leq"},
		{">=",    "geq",             "\\geq"},
		{"!=",    "not equals",      "\\neq"},

		{"|>",    "arrow maps to",   "\\mapsto"},
		{"->",    "rightarrow"},
		{"->",    "arrow to",        "\\to"},
		{"<-",    "leftarrow"},
		{"<->",   "leftrightarrow"},

		{"=>",    "Rightarrow"},
		{"=>",    "implies"},
		{"<=",    "Leftarrow"},
		{"<=",    "implied by",      "\\impliedby"},
		{"<=>",   "Leftrightarrow"},

		{"-->",   "longrightarrow"},
		{"-->",   "longrightarrow"},
		{"-->",   "longrightarrow"},
		{"<-->",  "longleftrightarrow"},

		{"==>",   "Longrightarrow"},
		{"<==",   "Longleftarrow"},
		{"<==>",  "Longleftrightarrow"},

		{"EE",    "exists"},
		{"AA",    "forall"},

		{"oo",    "infinity",        "\\infty"},
		{"xx",    "cross",           "\\times"},
		{"**",    "cdot"},
		{"inv",   "inverse",         "^{-1}"},

		{"cc",    "subset"},
		{"notin", "not in",          "\\not\\in"},
		{"nn",    "cap"},
		{"uu",    "cup"}} do
		local trig,name,str = unpack(e)
		table.insert(snipps, gen_text_and_math_snip(true, trig, str or ("\\"..name), name))
		-- table.insert(snipps, gen_text_and_math_snip(false, trig, str or ("\\"..name), name))
	end

	for _,e in ipairs{
		{"int",  "Integral"},
		{"sum",  "Summation"},
		{"prod", "Product"}} do
		local trig,name,str = unpack(e)
		table.insert(snipps, s({trig=trig, name=name}, fmt(
			"\\"..(str or trig) .. [[_{<start>}^{<stop>}]],
			{
				start = i(1, "n = 1"),
				stop  = i(2, "\\infty"),
			}
		), {
				-- condition = expand_cond.in_mathzone,
				-- show_condition = expand_cond.in_mathzone
			})
		)
	end

	for _,e in ipairs{
		{"lb",  "large bracket [", "[", "]"},
		{"lp",  "large paren (", "(", ")"},
		{"lc",  "large curly {", "{", "}"},
		{"la",  "large abs |", "|", "|"},
		{"ceil",  "ceil", "ceil"},
		{"floor", "floor", "floor"}} do
		local trig,name,strL,strR = unpack(e)
		table.insert(snipps, s({trig=trig, name=name}, fmt(
			[[\left]].. (strL) .. [[ <text> \right]] .. (strR or strL),
			{
				text = i(1),
			}
		), {
				-- condition = expand_cond.in_mathzone,
				-- show_condition = expand_cond.in_mathzone
			})
		)
	end

	for _,e in ipairs{
		{"align",    "align environment"},
		{"aligned",  "aligned environment"},
		{"equation", "equation environment"}} do
		local trig,name,env = unpack(e)
		table.insert(snipps, s({trig=trig, name=name}, gen_env_node(env or trig), {
			-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
			})
		)
	end

	table.insert(snipps, s({trig="alignat", name="alignat-environment"}, fmt(
	[[
	\begin{alignat*}}{<cols>}
		<stop>
	\end{alignat*}]],
	{
		cols = i(1, "#columns"),
		stop = i(0),
	}), {
			-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)
	table.insert(snipps, s({trig="cases", name="custom cases"}, fmt(
	[[
	\begin{array}{@{}l@{\quad}l@{}}
		<stop>
	\end{array}]],
	{
		stop = i(0),
	}), {
			-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)


	table.insert(snipps, s({trig="t^^", wordTrig=false, name="text superscript"}, fmt(
	[[^\text{<1>}]],
	{
		[1] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone,
			-- show_condition = expand_cond.in_mathzone
		})
	)
	table.insert(snipps, s({trig="^^", wordTrig=false, name="superscript"}, fmt(
	[[^{<1>}]],
	{
		[1] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone,
			-- show_condition = expand_cond.in_mathzone
		})
	)

	table.insert(snipps, s({trig="t__", wordTrig=false, name="text subscript"}, fmt(
	[[_\text{<1>}]],
	{
		[1] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone,
			-- show_condition = expand_cond.in_mathzone
		})
	)

	table.insert(snipps, s({trig="__", wordTrig=false, name="subscript"}, fmt(
	[[_{<1>}]],
	{
		[1] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone,
			-- show_condition = expand_cond.in_mathzone
		})
	)

	table.insert(snipps, s({trig="sq", name="\\sqrt{}"}, fmt(
	[[\sqrt{<1>}]],
	{
		[1] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone,
			-- show_condition = expand_cond.in_mathzone
		})
	)

	-- TODO overline vs bar? also in text mode somehow?
	table.insert(snipps, s({trig="conj", name="conjugate"}, {t"\\overline{", i(1), t"}"}, {
		-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)

	table.insert(snipps, s({trig="bar", name="bar"}, {t"\\overline{", i(1), t"}"}, {
		-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)

	for _,e in ipairs{
		{"lim", "Limes", "lim"},
		{"UU",  "bigcup", "bugcup", "i \\in I"},
		{"NN",  "bigcap", "bigcap", "i \\in I"}} do
		local trig,name,str,def1 = unpack(e)
		table.insert(snipps, s({trig=trig, name=name}, fmt(
			"\\".. (str or name) .. [[_{<subs>}]],
			{
				subs = i(1, def1),
			}
		), {
				-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
			})
		)
	end

	table.insert(snipps, s({trig="bigfun", name="Big function"}, fmt(
	[[
	\begin{align*}
		<1>: <2> &\longrightarrow <3> \\\\
		<4> &\longmapsto <1r>(<4r>) = <0>
	.\end{{align*}}
	]], {
		[1] = i(1),
		[2] = i(2),
		[3] = i(3),
		[4] = i(4),
		["1r"] = rep(1),
		["4r"] = rep(4),
		[0] = i(1),
	}), {
			-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)

	table.insert(snipps, s({trig="fr", name="\\frac{}{}"}, fmt(
	[[\frac{<numer>}{<denom>}]],
	{
		numer = i(1),
		denom = i(2),
	}), {
			-- condition = expand_cond.in_mathzone, show_condition = expand_cond.in_mathzone
		})
	)
end

function snip_gen.text(snipps)
	for _,e in ipairs{
		{"ul",  "underline", "underline"},
		{"bo",  "bold", "textbf"},
		{"tt",  "typewriter", "texttt"},
		{"it", "italic", "textit"},

		{"#", "section", "section", 1001},
		{"##", "subsection", "subsection", 1002},
		{"###", "subsubsection", "subsubsection", 1003},
		{"####", "paragraph", "paragraph", 1004},
		{"#####", "subparagraph", "subparagraph", 1005}} do
		local trig,name,str,prio = unpack(e)
		table.insert(snipps, s({trig=trig, name=name, priority=prio}, fmt(
		"\\"..(str or trig) .. [[{<text>}]],
		{
			text = i(1),
		}
		))
		)
	end
end

function snip_gen.cite(snipps)
	table.insert(snipps, s({trig="biblatex"}, fmt(
	[[
	\usepackage[
		backend=biber,
		url=false,
		style=ieee,
		maxnames=4,
		minnames=3,
		maxcitenames=2,
		mincitenames=1,
		maxbibnames=99,
	]{biblatex}
	\bibliography{bibliography}
	]], {}))
	)

	table.insert(snipps, s({trig="print bib"}, fmt(
	[[
	% \microtypesetup{protrusion=true}
	\printbibliography{}
	% \microtypesetup{protrusion=false}
	]], {}))
	)

	table.insert(snipps, s({trig="pcite", name="cite with page"}, fmt(
	[[\cite[<page>]{<ref>}]],
	{
		ref  = i(1),
		page = i(2),
	}))
	)
	table.insert(snipps, s({trig="cite", name="cite"}, fmt(
	[[\<citeauthor><page>{<ref>}]],
	{
		ref=i(1),
		page=c(2, {
			sn(nil, {t("["), i(1), t("]")}),
			t(""),
		}),
		citeauthor=c(3, {
			t("cite"),
			t("citeauthor"),
			t("citeauthor"),
		}),
	}),
	{
		-- ensure that it only is expanded if not being inside the cite snippet
		condition = function(line_to_cursor,_,_) return line_to_cursor:match("%scite$") or line_to_cursor:match("^cite$") end
	})
	)
end

function snip_gen.tikz(snipps)
	-- TODO default chains setup
	-- helpers
	local function arrow(jump)
		return sn(jump, {
			t"> = ",
			c(1, {t"Stealth", t"Triangle", t"Latex"}),
			t"[scale=",
			i(2, "1"),
			t",round=",
			c(3, {t"false", t"true"}),
			t",open=",
			c(4, {t"false", t"true"}),
			t",]",
		})
	end

	-- snippets
	table.insert(snipps, s({trig="graph axis", name="Insert a coordinate system"}, fmt(
	[[
	\begin{axis} [
		font            = {<font>},
		line width      = {<line width>},
		width           = {<width>},
		xmin = {<xmin>}, xmax = {<xmax>}, ymin = {<ymin>}, ymax = {<ymax>},
		samples         = {<samples>},
		legend style    = {font=\scriptsize},
		grid            = major,
		grid style      = {gray!30},
		axis lines      = middle,
		axis line style = {->>},
		xlabel          = {<xlabel>},
		ylabel          = {<ylabel>},

		\addplot[]{<11>} node[] {};
		<0>
	\end{axis}
		]], {
		["font"]       = i(1,  "\\small"),
		["line width"] = i(2,  "0.4pt"),
		["width"]      = i(3,  "\\linewidth"),
		["xmin"]       = i(4,  "-5"),
		["xmax"]       = i(5,  "+5"),
		["ymin"]       = i(6,  "-5"),
		["ymax"]       = i(7,  "+5"),
		["samples"]    = i(8,  "25"),
		["xlabel"]     = i(9),
		["ylabel"]     = i(10),
		[11]           = i(11, "x^2"),
		[0]            = i(0),
	}), {show_condition = expand_cond.in_tikz, condition = expand_cond.in_tikz})
	)

	table.insert(snipps, s({trig="addplot"}, fmt(
	[[
		\addplot+[] <source> node[] {};
	]], {
		source = c(1, {
				sn(nil, {t"coordinates {", i(1, "(0,0)"), t("};")}),
				sn(nil, {t"table[", i(1), t("] {"), i(2, "filename"), t("}"), i(0), t(";")}),
				sn(nil, {t"{", i(1, "math expression"), t("};")}),
			}),
	}), {show_condition = expand_cond.in_tikz, condition = expand_cond.in_tikz})
	)

	table.insert(snipps, s({trig="automataPre", name="Insert an exmple preamble for automata"}, fmt(
	[[
	% needs \usetikzlibrary{automata,arrows.meta,positioning}
	\tikzset{
		automata/.style={
			->>,<arrow>,shorten >>=1pt,
			font = \small,
			initial text = {},
			every state/.style = {fill=white,draw=black,text=black,},
			every state/.style = {draw=blue!50,very thick,fill=blue!20,},
			every loop/.style  = {looseness=5,},
			node distance = 2.8cm,
		},
	}
	]], {
		arrow = arrow(1),
	}), {condition = expand_cond.line_begin})
	)

	table.insert(snipps, s({trig="automata", name="Insert an exmple for automata in tikz"}, fmt(
	[[
	\begin{tikzpicture}[automata]
		\node[state, initial, accepting] (0) {0};
		% use snippet "and" for node and "aed" for edges
	\end{tikzpicture}
	]], {}))
	)

	table.insert(snipps, s({trig="aed", name="edge in automata"}, fmt(
	[[\path (<src>) edge[<edge>] node[<node>] {<text>} (<dst>);]],
	{
		src  = i(1),
		dst  = i(2),
		text = i(3),
		node = i(4),
		edge = i(5),
	}), {condition = expand_cond.in_tikz, show_condition = expand_cond.in_tikz})
	)

	table.insert(snipps, s({trig="and", name="node in automata"}, fmt(
	[[\node[state,<acc>,<pos>=of <rel>] (<name>) {<text>};]],
	{
		name = i(1),
		text = rep(1),
		pos  = i(2, "right"),
		rel  = i(3),
		acc  = i(4, "accepting"),
	}), {condition = expand_cond.in_tikz, show_condition = expand_cond.in_tikz})
	)
end

function snip_gen.floats(snipps)
	for _,e in ipairs{
		{"fig", "figure", "figure", "fig"},
		{"tab", "table",  "table", "tab"}} do
		local trig,name,env,lbl = unpack(e)
		table.insert(snipps, s({trig=trig, name=name}, fmt(
		[[
		\begin{<env1>}
			\centering
			<content>
			\caption{<caption>.}
			\label{<lbl>:<label>}
		\end{<env2>}]],
		{
			env1    = t(env),
			env2    = t(env),

			content = c(1, {
				sn(nil, {t"\\includegraphics[", i(2), t"]{", i(1, "path"), t"}"}),
				sn(nil, {t"\\input{", i(1, "path"), t"}"}),
				i(nil),
			}),

			caption = i(2),
			label   = i(3),
			lbl     = t(lbl),
		}))
		)
	end
end

function snip_gen.item(snipps)
	table.insert(snipps, s("item", fmt(
	[[\begin{<env>}<enumType>]] .. "\n" ..
	[[	\item <in>]] .. "\n" ..
	[[\end{<env2>}]],
	{
		["env"]      = c(1, {t("itemize"), t("enumerate"), t("description"), i(nil, "manual")}),
		["env2"]     = rep(1),
		["enumType"] = d(2, itemI, {1}),
		["in"]       = i(0),
	}), {condition = expand_cond.line_begin})
	)
end

function snip_gen.tables(snipps)
	table.insert(snipps, s({trig="tabXEntry", name="customizable tabularX entry"}, fmt(
	[[>>{\setlength\hsize{<frac>\hsize}\raggedright\arraybackslash}X]],
	{
		["frac"] = i(1, "frac"),
	}))
	)

	table.insert(snipps, s({trig="tabularx", name="tabularx"}, fmt(
	[[
	\begin{tabularx}{<width>}{<spec>}
	<content>
	\end{tabularx}
	]], {
		["width"]   = i(1, [[\linewidth]]),
		["spec"]    = i(2),
		["content"] = i(3),
	}),
	{
		condition = expand_cond.line_begin,
	})
	)
end

------------------------------------------
-- SNIPPETS FOR SPECIFIC LATEX PACKAGES --
------------------------------------------

function snip_gen.listings(snipps)
	table.insert(snipps, s({trig="lsti", name="lstinline"}, fmt(
	[[\lstinline|<code>|]],
	{
		code = i(1),
	}))
	)
end

function snip_gen.glossaries(snipps)
	table.insert(snipps, s({trig="default glossaries"}, fmt(
	[[
	\usepackage[acronym,nomain]{glossaries-extra}
	\usepackage{glossaries-prefix}
	\setabbreviationstyle{long-short}
	\makeglossaries
	]], {}))
	)

	table.insert(snipps, s({trig="newabbrev"}, fmt(
	[[
	\newabbreviation[<opts>]{<key>}{<short>}{<long>}
	]], {
			key = i(1, "key"),
			short = i(2, "short"),
			long = i(3, "long"),
			opts = c(4, {
				sn(nil, {t("prefixfirst={"), i(1, "a\\ "), t("}, prefix={"), i(2, "a\\ "), t("}")}),
				i(nil),
			}),
			-- sn(nil, {i(nil, "0.49"), t[[\linewidth]]}),
		}))
	)

	table.insert(snipps, s({trig="glos", name="glossaries"}, fmt(
	[[\<prefix>gls<suffix>{<ref>}]],
	{
		prefix=c(1, {t(""), t("p")}),
		suffix=c(2, {t(""), t("l"), t("s"), t("pl")}),
		ref=i(3),
	}))
	)
end

function snip_gen.tcolorbox(snipps)
	table.insert(snipps, s({trig="tcolor_def_marker", name="marker box"}, fmt(
		[[
		\newtcolorbox{marker}[1][]{enhanced,
			before skip balanced=2mm,after skip balanced=3mm,
			boxrule=0.4pt,left=5mm,right=2mm,top=1mm,bottom=1mm,
			colback=yellow!50,
			colframe=yellow!20!black,
			sharp corners,rounded corners=southeast,arc is angular,arc=3mm,
			underlay={%
				\path[fill=tcbcolback!80!black] ([yshift=3mm]interior.south east)--++(-0.4,-0.1)--++(0.1,-0.2);
				\path[draw=tcbcolframe,shorten <<=-0.05mm,shorten >>=-0.05mm] ([yshift=3mm]interior.south east)--++(-0.4,-0.1)--++(0.1,-0.2);
				\path[fill=yellow!50!black,draw=none] (interior.south west) rectangle node[white]{\Huge\bfseries !} ([xshift=4mm]interior.north west);
				},
			drop fuzzy shadow,#1}
		]], {}))
	)

	table.insert(snipps, s({trig="tcolor_def_commandbox", name="command box inline"}, fmt(
		[[
		% needs lstlisting
		\NewTotalTCBox{\commandbox}{ s v }
			{verbatim,colupper=white,colback=black!75!white,colframe=black}
			{\IfBooleanT{#1}{\textcolor{red}{\ttfamily\bfseries >> }}%
		\lstinline[language=command.com,keywordstyle=\color{blue!35!white}\bfseries]^#2^}
		]], {}))
	)

	table.insert(snipps, s({trig="tcolor_def_niceTitle", name="box with 3d title on top c.f. page 182 in manual"}, fmt(
		[[
		% \usepackage{varwidth}
		\newtcolorbox{mybox}[2][]{enhanced,skin=enhancedlast jigsaw,
			attach boxed title to top left={xshift=-4mm,yshift=-0.5mm},
			fonttitle=\bfseries\sffamily,varwidth boxed title=0.7\linewidth,
			colbacktitle=blue!45!white,colframe=red!50!black,
			interior style={top color=blue!10!white,bottom color=red!10!white},
			boxed title style={empty,arc=0pt,outer arc=0pt,boxrule=0pt},
			underlay boxed title={
			\fill[blue!45!white] (title.north west) -- (title.north east)
			-- +(\tcboxedtitleheight-1mm,-\tcboxedtitleheight+1mm)
			-- ([xshift=4mm,yshift=0.5mm]frame.north east) -- +(0mm,-1mm)
			-- (title.south west) -- cycle;
			\fill[blue!45!white!50!black] ([yshift=-0.5mm]frame.north west)
			-- +(-0.4,0) -- +(0,-0.3) -- cycle;
			\fill[blue!45!white!50!black] ([yshift=-0.5mm]frame.north east)
			-- +(0,-0.3) -- +(0.4,0) -- cycle; },
		title={#2},#1}
		]], {}))
	)

	-- table.insert(snipps, s({trig="tcolor_def_marker", name="marker box"}, fmt(
	-- 	[[
	-- 	]],
	-- 	{
	-- 	}))
	-- )
end

local snipps = {}

table.insert(snipps, s({trig="title", name="storing commands for maketitle"}, fmt(
	[[
	\title{<title>}
	\author{<author>}
	% \date{}

	]],
	{
		title=i(1),
		author=i(2),
	}))
)

for _,foo in pairs(snip_gen) do
	assert(type(foo) == "function", "invalid field")
	foo(snipps)
end

return snipps
