require("bryant.remap")
require("bryant.set")
require("bryant.lazy_init")

local augroup = vim.api.nvim_create_augroup
local BryantGroup = augroup('BryantGroup', {})
local autocmd = vim.api.nvim_create_autocmd

-- Override only on current buffer
autocmd('LspAttach', {
    group = BryantGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        -- Existing keymaps
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("v", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        -- Add folding setup
        vim.api.nvim_buf_set_option(e.buf, 'foldmethod', 'expr')
        vim.api.nvim_buf_set_option(e.buf, 'foldexpr', 'nvim_treesitter#foldexpr()')
        vim.api.nvim_buf_set_option(e.buf, 'foldlevel', 99) -- Start with all folds open
        -- Add fold toggling keymap
        vim.keymap.set("n", "<space>z", "za", { noremap = true, silent = true, buffer = e.buf })
        -- formatting
        vim.keymap.set("v", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
        vim.keymap.set("n", "<leader>f", function()
            vim.cmd("lua vim.lsp.buf.format({async = false})")
        end, opts)
        -- no highlights after accepting suggestions
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { bg = "NONE", fg = "#569CD6" })
    end
})
-- Set up nvim-lightbulb
autocmd({ "CursorHold", "CursorHoldI" }, {
    group = BryantGroup,
    callback = function()
        require('nvim-lightbulb').update_lightbulb()
    end
})
