require("bryant")

-- Restore cursor shape on exit
vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
        vim.opt.guicursor = ""
        io.write("\027[4 q") -- Set cursor to steady underline (horizontal)
    end
})
