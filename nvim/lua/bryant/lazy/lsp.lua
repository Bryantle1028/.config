return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "j-hui/fidget.nvim",
        "nvimtools/none-ls.nvim",
        "kosayoda/nvim-lightbulb",
        "stevearc/aerial.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "marksman",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                    }
                end,
                ["pyright"] = function()
                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    reportMissingImports = "none",
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                    diagnosticMode = "workspace",
                                    typeCheckingMode = "basic",
                                    autoImportCompletions = true,
                                    extraPaths = { vim.fn.expand("$CONDA_PREFIX/lib/python3.11/site-packages") },
                                    diagnosticSeverityOverrides = {
                                        reportAttributeAccessIssue = "none",
                                    },
                                },
                            },
                        },
                        root_dir = function(fname)
                            local util = require("lspconfig.util")
                            local git_root = util.find_git_ancestor(fname)
                            local current_dir = util.path.dirname(fname)
                            return git_root or current_dir
                        end,
                    }
                end,
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "LuaJIT" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                            }
                        }
                    }
                end,
            }
        })

        local null_ls = require("null-ls")
        local h = require("null-ls.helpers")
        local methods = require("null-ls.methods")
        local FORMATTING = methods.internal.FORMATTING

        -- Create custom formatter using ruff format only (no linting)
        local ruff_format = h.make_builtin({
            name = "ruff_format",
            meta = {
                url = "https://github.com/astral-sh/ruff",
                description = "An extremely fast Python formatter, written in Rust.",
            },
            method = FORMATTING, -- Only use formatting, not diagnostics
            filetypes = { "python" },
            generator_opts = {
                command = "ruff",
                args = { "format", "$FILENAME" },
                to_temp_file = true,
                from_temp_file = true,
            },
            factory = h.formatter_factory,
        })


        local prettier = null_ls.builtins.formatting.prettier.with({
            filetypes = { "markdown", "yaml", "json" },
            prefer_local = "node_modules/.bin",
            extra_args = {
                "--prose-wrap", "always",
                "--print-width", "100"
            },
        })


        null_ls.setup({
            sources = {
                ruff_format,
                prettier,
                null_ls.builtins.diagnostics.markdownlint,
            },
        })

        require("nvim-lightbulb").setup({
            autocmd = { enabled = true }
        })

        require('aerial').setup()

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'nvim_lsp_signature_help' },
            }),
            experimental = {
                ghost_text = true,
            },
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
