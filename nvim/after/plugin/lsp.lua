local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.buffer_autoformat()
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "]g", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "[g", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "clangd", "rust_analyzer", "pyright" },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            require 'lspconfig'.lua_ls.setup {
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = {
                                        vim.env.VIMRUNTIME
                                    }
                                }
                            }
                        })

                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end
                    return true
                end
            }
        end,
        rust_analyzer = function()
            require 'lspconfig'.rust_analyzer.setup {
                require('rust-tools').setup({
                    tools = {
                        inlay_hints = {
                            -- automatically set inlay hints (type hints)
                            -- default: true
                            auto = true,

                            -- Only show inlay hints for the current line
                            only_current_line = false,

                            -- whether to show parameter hints with the inlay hints or not
                            -- default: true
                            show_parameter_hints = true,

                            -- prefix for parameter hints
                            -- default: "<-"
                            parameter_hints_prefix = "<- ",

                            -- prefix for all the other hints (type, chaining)
                            -- default: "=>"
                            other_hints_prefix = "=> ",

                            -- whether to align to the length of the longest line in the file
                            max_len_align = false,

                            -- padding from the left if max_len_align is true
                            max_len_align_padding = 1,

                            -- whether to align to the extreme right or not
                            right_align = false,

                            -- padding from the right if right_align is true
                            right_align_padding = 7,

                            -- The color of the hints
                            highlight = "Comment",
                        },
                    },
                    server = {
                        on_attach = function(_, bufnr)
                            vim.keymap.set('n', '<leader>vca', require('rust-tools').hover_actions.hover_actions,
                                { buffer = bufnr })
                        end
                    },
                }),
            }
        end
    },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),

        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil,
    })
})
