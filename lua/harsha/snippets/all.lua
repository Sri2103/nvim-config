local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("funcdoc", {
        t({
            "/**",
            " * ",
        }),
        i(1, "Function summary"),
        t({
            "",
            " *",
            " * Inputs:",
            " *   ",
        }),
        i(2, "params"),
        t({
            "",
            " * Outputs:",
            " *   ",
        }),
        i(3, "returns"),
        t({
            "",
            " * Notes:",
            " */",
        }),
        i(0),
    }),
}
