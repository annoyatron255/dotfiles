local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local isn = ls.indent_snippet_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local types = require("luasnip.util.types")

ls.config.set_config({
	history = false,
	updateevents = "TextChanged,TextChangedI",
	ext_base_prio = 300,
	ext_prio_increase = 1,
	enable_autosnippets = true,
	store_selection_keys = "<Tab>"
})

-- 'recursive' dynamic snippet. Expands to some text followed by itself.
local rec_ls
rec_ls = function()
	return sn(
		nil,
		c(1, {
			-- Order is important, sn(...) first would cause infinite loop of expansion.
			t(""),
			sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
		})
	)
end

local function prepend_lines(str, prepend)
	local result = {}
	for _, line in ipairs(str) do
		table.insert(result, prepend .. line)
	end
	return result
end

local function in_mathzone()
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

ls.autosnippets = {
	all = { },
	tex = {
		s({trig = "^(%s*)beg", regTrig = true}, {
			f(function(args)
				return args[1].captures[1] .. "\\begin{"
			end, {}),
			i(1),
			t({"}", ""}), f(function(args)
				if next(args[1].env.SELECT_RAW) == nil then
					return "\t"
				else
					return prepend_lines(args[1].env.SELECT_RAW,
						"\t" .. args[1].captures[1])
				end
			end, {}), i(0),
			t({"", "\\end{"}), r(1),
			t("}"),
		}),
		s({trig = "dm", regTrig = true}, {
			t({"\\[", "\t"}),
			d(1, function(args, state)
				if args[1].env.SELECT_RAW[1] == nil then
					return sn(nil, i(1))
				else
					return isn(nil, t(args[1].env.TM_SELECTED_TEXT), "$PARENT_INDENT\t")
				end
			end, {}),
			t({"", "\\]"}), i(0)
		}),
		s("itemize", {
			t({ "\\begin{itemize}", "\t\\item " }),
			i(1),
			d(2, rec_ls, {}),
			t({ "", "\\end{itemize}" }),
		}),
	}
}
