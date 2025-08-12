return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            disable_filetype = { "TelescopePrompt" },
            enable_check_bracket_line = false,
            enable_bracket_in_quote = true,
            enable_bracket_in_nested_quotes = true,
            enable_moveright = true,
            ignored_next_char = "%w",
            enable_afterquote = true,
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
        end,
    },
}
