return {
    "petertriho/nvim-scrollbar",
    dependencies = {
        "kevinhwang91/nvim-hlslens",
        "tiagovla/tokyodark.nvim",
    },
    config = function()
        local colors = require("bryant.lazy.colors")
        local lighter_bg_highlight = "#333856"
        local scrollbar_color = "#FF9E64"  -- Orange color for the scrollbar

        -- Set up hlslens first
        require("hlslens").setup({
            build_position_cb = function(plist, _, _, _)
                require("scrollbar.handlers.search").handler.show(plist.start_pos)
            end,
        })

        -- Set up scrollbar
        require("scrollbar").setup({
            folds = 1000,
            max_lines = false,
            hide_if_all_visible = false,
            handle = {
                color = scrollbar_color,  -- Set the scrollbar color to white
            },
            marks = {
                Search = { color = colors.orange, highlight = "ScrollbarSearch" },
                Error = { color = colors.error },
                Warn = { color = colors.warning },
                Info = { color = colors.info },
                Hint = { color = colors.hint },
                Misc = { color = colors.purple },
            },
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = true,
                handle = true,
                search = true,
            },
            render_at_end = true,
        })

        -- Integrate scrollbar with hlslens
        require("scrollbar.handlers.search").setup({
            -- Override the lens setup here if needed
            -- override_lens = function() end,
        })

        -- Set up autocmd to hide search handler when leaving cmdline
        vim.api.nvim_create_autocmd("CmdlineLeave", {
            pattern = ":",
            callback = function()
                require("scrollbar.handlers.search").handler.hide()
            end,
        })

        -- Explicitly set the ScrollbarSearch highlight
        vim.api.nvim_set_hl(0, "ScrollbarSearch", { fg = colors.orange, bg = lighter_bg_highlight })

        -- Set the ScrollbarHandle highlight to white
        vim.api.nvim_set_hl(0, "ScrollbarHandle", { fg = scrollbar_color, bg = scrollbar_color })
    end,
}
