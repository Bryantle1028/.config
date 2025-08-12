return {
    "towolf/vim-helm",
    ft = { "yaml", "yml", "helm" },
    config = function()
        vim.g.helm_template_highlighting = 1

        -- Create helm filetype detection
        local augroup = vim.api.nvim_create_augroup
        local HelmGroup = augroup('HelmGroup', {})
        local autocmd = vim.api.nvim_create_autocmd

        autocmd({ "BufRead", "BufNewFile" }, {
            group = HelmGroup,
            pattern = { "*.yaml", "*.yml" },
            callback = function()
                local lines = vim.api.nvim_buf_get_lines(0, 0, 20, false)
                for _, line in ipairs(lines) do
                    if line:match("{{") or line:match("}}") then
                        vim.bo.filetype = "helm"
                        break
                    end
                end
            end
        })
    end
}

