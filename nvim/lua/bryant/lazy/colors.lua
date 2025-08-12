return {
    {
        "tiagovla/tokyodark.nvim",
        opts = {
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[
                colorscheme tokyodark
                highlight Visual guibg=#333856
            ]]
        end,
    }
}
