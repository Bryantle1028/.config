return {
    "dstein64/nvim-scrollview",
    config = function()
        require('scrollview').setup({
            excluded_filetypes = {'NvimTree'},
            current_only = true,
        })
    end
}
