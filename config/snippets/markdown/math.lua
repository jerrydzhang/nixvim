local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local function in_math()
	local captures = vim.treesitter.get_captures_at_cursor()
	for _, capture in ipairs(captures) do
		if capture == "markup.math" then
			return true
		end
	end
	return false
end

local get_visual = function(args, parent)
	if #parent.snippet.env.LS_SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
	else -- If LS_SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

local reg = {
	s(
		{ trig = "mm", dscr = "math mode" },
		fmta(
			[[
			$$
			\begin{align*}
			<>
			\end{align*}
			$$
			]],
			{ i(1) }
		),
		{ condition = line_begin }
	),
	s({ trig = "im", dscr = "inline math" }, fmta("$<>$", { i(1) })),
}

local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t("\\\\"))
		if j ~= rows then
			table.insert(nodes, t({ "", "" }))
		end
	end
	return sn(nil, nodes)
end

local brackets = {
	a = { "\\langle", "\\rangle" },
	A = { "Angle", "Angle" },
	b = { "brack", "brack" },
	B = { "Brack", "Brack" },
	c = { "brace", "brace" },
	m = { "|", "|" },
	p = { "(", ")" },
}

local special = {
	s(
		{
			trig = "([bBpvV])m(%d+)x(%d+)([ar])",
			regTrig = true,
			name = "matrix",
			dscr = "matrix trigger lets go",
			snippetType = "autosnippet",
		},
		fmt(
			[[
    \begin{<>}<>
    <>
    \end{<>}]],
			{
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
				f(function(_, snip) -- augments
					if snip.captures[4] == "a" then
						local out = string.rep("c", tonumber(snip.captures[3]) - 1)
						return "[" .. out .. "|c]"
					end
					return ""
				end),
				d(1, mat),
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
			},
			{ delimiters = "<>" }
		)
	),
	s(
		{
			trig = "lr([aAbBcmp])",
			name = "left right",
			dscr = "left right delimiters",
			regTrig = true,
			hidden = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[
    \left<> <> \right<><>
    ]],
			{
				f(function(_, snip)
					local cap = snip.captures[1] or "p"
					return brackets[cap][1]
				end),
				d(1, get_visual),
				f(function(_, snip)
					local cap = snip.captures[1] or "p"
					return brackets[cap][2]
				end),
				i(0),
			}
		),
		{ condition = in_math, show_condition = in_math }
	),
}

local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
	local capture = parent.snippet.env.POSTFIX_MATCH
	if #capture > 0 then
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), t(capture), t(user_arg2), i(0) }
			)
		)
	else
		local visual_placeholder = ""
		if #parent.snippet.env.SELECT_RAW > 0 then
			visual_placeholder = parent.snippet.env.SELECT_RAW
		end
		return sn(
			nil,
			fmta(
				[[
        <><><><>
        ]],
				{ t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0) }
			)
		)
	end
end

local generate_fraction = function(_, snip)
	local stripped = snip.captures[1]
	local depth = 0
	local j = #stripped
	while true do
		local c = stripped:sub(j, j)
		if c == "(" then
			depth = depth + 1
		elseif c == ")" then
			depth = depth - 1
		end
		if depth == 0 then
			break
		end
		j = j - 1
	end
	return sn(
		nil,
		fmta(
			[[
        <>\frac{<>}{<>}
        ]],
			{ t(stripped:sub(1, j - 1)), t(stripped:sub(j)), i(1) }
		)
	)
end

local auto = {
	s(
		{ trig = "ff", dscr = "fraction", regTrig = true, snippetType = "autosnippet" },
		fmta([[<>\frac{<>}{<>}]], { f(function(_, snip)
			return snip.captures[1]
		end), i(1), i(2) }),
		{ condition = in_math }
	),
	s(
		{
			trig = "((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/",
			name = "fraction",
			dscr = "auto fraction 1",
			trigEngine = "ecma",
			snippetType = "autosnippet",
		},
		fmta(
			[[
    \frac{<>}{<>}<>
    ]],
			{ f(function(_, snip)
				return snip.captures[1]
			end), i(1), i(0) }
		),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{
			trig = "(^.*\\))/",
			name = "fraction",
			dscr = "auto fraction 2",
			trigEngine = "ecma",
			snippetType = "autosnippet",
		},
		{ d(1, generate_fraction) },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "ee", dscr = "euler's", regTrig = true, snippetType = "autosnippet" },
		fmta([[<>e^{<>}]], { f(function(_, snip)
			return snip.captures[1]
		end), d(1, get_visual) }),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "%.%.%.", dscr = "ellipsis", regTrig = true, snippetType = "autosnippet" },
		t("\\dots"),
		{ condition = in_math, show_condition = in_math }
	),
	postfix(
		{ trig = "vec", snippetType = "autosnippet" },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\vec{", "}" } }) },
		{ condition = in_math, show_condition = in_math }
	),
	postfix(
		{ trig = "bar", snippetType = "autosnippet" },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\bar{", "}" } }) },
		{ condition = in_math, show_condition = in_math }
	),
	postfix(
		{ trig = "hat", snippetType = "autosnippet" },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\hat{", "}" } }) },
		{ condition = in_math, show_condition = in_math }
	),
	postfix(
		{ trig = "til", snippetType = "autosnippet" },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\tilde{", "}" } }) },
		{ condition = in_math, show_condition = in_math }
	),
	postfix(
		{ trig = "bb", snippetType = "autosnippet" },
		{ d(1, dynamic_postfix, {}, { user_args = { "\\mathbb{", "}" } }) },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "td", dscr = "superscript", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("^{<>}", { i(1) }),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "_", dscr = "subscript", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("_{<>}", { i(1) }),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "_", dscr = "subscript", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
		fmta("_{<>}", { i(1) }),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "sr", wordTrig = false, snippetType = "autosnippet" },
		{ t("^2") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "cb", wordTrig = false, snippetType = "autosnippet" },
		{ t("^3") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "compl", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{c}") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "vtr", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{T}") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = "inv", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{-1}") },
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{
			trig = "lim",
			name = "lim(sup|inf)",
			dscr = "lim(sup|inf)",
			regTrig = true,
			snippetType = "autosnippet",
		},
		fmta(
			[[ 
    \lim<><><>
    ]],
			{
				c(1, { t(""), t("sup"), t("inf") }),
				c(2, { t(""), fmta([[_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }) }),
				i(0),
			}
		),
		{ condition = in_math, show_condition = in_math }
	),

	s(
		{ trig = "sum", name = "summation", dscr = "summation", snippetType = "autosnippet" },
		fmta(
			[[
    \sum<> <>
    ]],
			{ c(1, { fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty") }), t("") }), i(0) }
		),
		{ condition = in_math, show_condition = in_math }
	),

	s(
		{ trig = "prod", name = "product", dscr = "product", snippetType = "autosnippet" },
		fmta(
			[[
    \prod<> <>
    ]],
			{ c(1, { fmta([[_{<>}^{<>}]], { i(1, "i = 0"), i(2, "\\infty") }), t("") }), i(0) }
		),
		{ condition = in_math, show_condition = in_math }
	),
}

local greek = {
	s(
		{ trig = ";al", dscr = "alpha", regTrig = true, snippetType = "autosnippet" },
		t("\\alpha"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":AL", dscr = "Alpha", regTrig = true, snippetType = "autosnippet" },
		t("\\Alpha"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";be", dscr = "beta", regTrig = true, snippetType = "autosnippet" },
		t("\\beta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":BE", dscr = "Beta", regTrig = true, snippetType = "autosnippet" },
		t("\\Beta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ga", dscr = "gamma", regTrig = true, snippetType = "autosnippet" },
		t("\\gamma"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":GA", dscr = "Gamma", regTrig = true, snippetType = "autosnippet" },
		t("\\Gamma"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";de", dscr = "delta", regTrig = true, snippetType = "autosnippet" },
		t("\\delta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":DE", dscr = "Delta", regTrig = true, snippetType = "autosnippet" },
		t("\\Delta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ep", dscr = "epsilon", regTrig = true, snippetType = "autosnippet" },
		t("\\epsilon"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":EP", dscr = "Epsilon", regTrig = true, snippetType = "autosnippet" },
		t("\\Epsilon"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ze", dscr = "zeta", regTrig = true, snippetType = "autosnippet" },
		t("\\zeta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":ZE", dscr = "Zeta", regTrig = true, snippetType = "autosnippet" },
		t("\\Zeta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";et", dscr = "eta", regTrig = true, snippetType = "autosnippet" },
		t("\\eta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":ET", dscr = "Eta", regTrig = true, snippetType = "autosnippet" },
		t("\\Eta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";th", dscr = "theta", regTrig = true, snippetType = "autosnippet" },
		t("\\theta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":TH", dscr = "Theta", regTrig = true, snippetType = "autosnippet" },
		t("\\Theta"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";io", dscr = "iota", regTrig = true, snippetType = "autosnippet" },
		t("\\iota"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":IO", dscr = "Iota", regTrig = true, snippetType = "autosnippet" },
		t("\\Iota"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ka", dscr = "kappa", regTrig = true, snippetType = "autosnippet" },
		t("\\kappa"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":KA", dscr = "Kappa", regTrig = true, snippetType = "autosnippet" },
		t("\\Kappa"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";la", dscr = "lambda", regTrig = true, snippetType = "autosnippet" },
		t("\\lambda"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":LA", dscr = "Lambda", regTrig = true, snippetType = "autosnippet" },
		t("\\Lambda"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";mu", dscr = "mu", regTrig = true, snippetType = "autosnippet" },
		t("\\mu"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":MU", dscr = "Mu", regTrig = true, snippetType = "autosnippet" },
		t("\\Mu"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";nu", dscr = "nu", regTrig = true, snippetType = "autosnippet" },
		t("\\nu"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":NU", dscr = "Nu", regTrig = true, snippetType = "autosnippet" },
		t("\\Nu"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";xi", dscr = "xi", regTrig = true, snippetType = "autosnippet" },
		t("\\xi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":XI", dscr = "Xi", regTrig = true, snippetType = "autosnippet" },
		t("\\Xi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";pi", dscr = "pi", regTrig = true, snippetType = "autosnippet" },
		t("\\pi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":PI", dscr = "Pi", regTrig = true, snippetType = "autosnippet" },
		t("\\Pi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";rh", dscr = "rho", regTrig = true, snippetType = "autosnippet" },
		t("\\rho"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":RH", dscr = "Rho", regTrig = true, snippetType = "autosnippet" },
		t("\\Rho"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";si", dscr = "sigma", regTrig = true, snippetType = "autosnippet" },
		t("\\sigma"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":SI", dscr = "Sigma", regTrig = true, snippetType = "autosnippet" },
		t("\\Sigma"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ta", dscr = "tau", regTrig = true, snippetType = "autosnippet" },
		t("\\tau"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":TA", dscr = "Tau", regTrig = true, snippetType = "autosnippet" },
		t("\\Tau"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";up", dscr = "upsilon", regTrig = true, snippetType = "autosnippet" },
		t("\\upsilon"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":UP", dscr = "Upsilon", regTrig = true, snippetType = "autosnippet" },
		t("\\Upsilon"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ph", dscr = "phi", regTrig = true, snippetType = "autosnippet" },
		t("\\phi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":PH", dscr = "Phi", regTrig = true, snippetType = "autosnippet" },
		t("\\Phi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ch", dscr = "chi", regTrig = true, snippetType = "autosnippet" },
		t("\\chi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":CH", dscr = "Chi", regTrig = true, snippetType = "autosnippet" },
		t("\\Chi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";ps", dscr = "psi", regTrig = true, snippetType = "autosnippet" },
		t("\\psi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":PS", dscr = "Psi", regTrig = true, snippetType = "autosnippet" },
		t("\\Psi"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ";om", dscr = "omega", regTrig = true, snippetType = "autosnippet" },
		t("\\omega"),
		{ condition = in_math, show_condition = in_math }
	),
	s(
		{ trig = ":OM", dscr = "Omega", regTrig = true, snippetType = "autosnippet" },
		t("\\Omega"),
		{ condition = in_math, show_condition = in_math }
	),
}

local result = {}
for _, i in ipairs({ reg, special, auto, greek }) do -- Iterate over all given tables
	for _, j in ipairs(i) do
		table.insert(result, j)
	end
end

return result
