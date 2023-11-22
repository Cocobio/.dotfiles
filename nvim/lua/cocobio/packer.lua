-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Colorschemes!
    use { "catppuccin/nvim", as = "catppuccin", config = function()
        vim.cmd.colorscheme "catppuccin"
    end }
    use { "folke/tokyonight.nvim" }
    use { 'talha-akram/noctis.nvim' }
    use { 'rose-pine/neovim', as = 'rose-pine', }
    use { 'nyoom-engineering/oxocarbon.nvim' }

    use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'} )
    use( 'nvim-treesitter/playground' )

    use( 'theprimeagen/harpoon' )

    use( 'mbbill/undotree' )
    use( 'tpope/vim-fugitive' )

    use( 'b3nj5m1n/kommentary' )

    use( 'm4xshen/autoclose.nvim' )

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.api.nvim_command, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    use "lukas-reineke/indent-blankline.nvim"

    use {
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                -- config
                theme = 'hyper',
                disable_move = true,
                config = {
                    week_header = {
                        enable = true,
                    },
                    shortcut = {
                        { icon = '󰊳 ', icon_hl = "@variable", desc = 'Update', group = '@property',
                        action = function ()
                            vim.cmd(':so ~/.dotfiles/nvim/lua/cocobio/packer.lua')
                            vim.cmd(':PackerSync')
                        end,
                        key = 'u'
                    },
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'Find Files',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        desc = ' Open Browser',
                        group = 'DiagnosticHint',
                        action = function ()
                            local api = require'nvim-tree.api'
                            api.tree.open{current_window=true}
                        end,
                        key = 'e',
                    },
                    {
                        desc = ' dotfiles',
                        group = 'DashboardProjectTitle',
                        action = function()
                            local api = require "nvim-tree.api"
                            vim.cmd(":cd ~/.dotfiles/")
                            api.tree.open{current_window=true}
                        end,
                        key = 'd',
                    },
                    {
                        desc = '󰗼 Quit',
                        group = 'Number',
                        action = 'quit',
                        key = 'q',
                    },
                }
            }
        }
        end,
        requires = {'nvim-tree/nvim-web-devicons'}
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    use 'simrat39/symbols-outline.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {
        'VonHeikemen/fine-cmdline.nvim',
        requires = {
            {'MunifTanjim/nui.nvim'}
        }
    }

    -- For autosave of nvim sessions :)
    use 'tpope/vim-obsession'
end)
