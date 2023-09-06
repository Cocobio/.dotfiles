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
                theme = 'doom',
                config = {
                    header = {"Header?"}, --your header
                    center = {
                        {
                            icon = ' ',
                            icon_hl = 'Title',
                            desc = 'Find File           ',
                            desc_hl = 'String',
                            key = 'b',
                            keymap = 'SPC f f',
                            key_hl = 'Number',
                            action = 'lua print(2)'
                        },
                        {
                            icon = ' ',
                            desc = 'Find Dotfiles',
                            key = 'f',
                            keymap = 'SPC f d',
                            action = 'lua print(3)'
                        },
                    },
                    footer = {"Footer"}  --your footer
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
end)
