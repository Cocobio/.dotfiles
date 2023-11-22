local api = require 'nvim-tree.api'

-- Nice command line :)
vim.api.nvim_set_keymap('n', ':', '<cmd>FineCmdline<CR>', { noremap = true })

-- Mapping ctrl-s as saving (updating) file
vim.keymap.set("n", "<C-s>", vim.cmd.update, { desc = "Save current file" })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", function() api.tree.toggle() end,
    { desc = "Project view" })
vim.keymap.set("n", "<leader>pr",
    function()
        api.tree.close()
        local file_path = vim.api.nvim_buf_get_name(0)
        file_path = file_path:sub(0, file_path:match '^.*()/')
        vim.cmd(":cd " .. file_path)
        api.tree.open()
    end,
    { desc = "Set Project at File" })

-- Moving through nvim windows
vim.keymap.set("n", "<C-h>", function() vim.cmd(":wincmd h") end)
vim.keymap.set("n", "<C-j>", function() vim.cmd(":wincmd j") end)
vim.keymap.set("n", "<C-k>", function() vim.cmd(":wincmd k") end)
vim.keymap.set("n", "<C-l>", function() vim.cmd(":wincmd l") end)

-- Mapping tab manipullation
vim.keymap.set("n", "<leader><Tab>", vim.cmd.tabnext, { desc = "Next nvim tab." })
vim.keymap.set("n", "<leader><S-Tab>", vim.cmd.tabprev, { desc = "Prev nvim tab." })
vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew, { desc = "New nvim tab." })
vim.keymap.set("n", "<leader>tq", vim.cmd.tabclose, { desc = "Close nvim tab." })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Mapping some actions to keys
-- tabs in view selected mode
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- With kommentary
vim.keymap.set("n", "<C-/>", "<Plug>kommentary_line_default")
vim.keymap.set("v", "<C-/>", "<Plug>kommentary_visual_default<C-c>")
vim.keymap.set("n", "<C-_>", "<Plug>kommentary_line_default")
vim.keymap.set("v", "<C-_>", "<Plug>kommentary_visual_default<C-c>")
-- vim.keymap.set("")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- When delitting highligh it does not overwrite the yanked buffer
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })

-- system clipboard yank
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Using Ctrl+c as Esc?
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP buffer format" })

-- Not quite sure yet...
--[[ vim.keymap.set("n", "<c-k>", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<c-j>", "<cmd>cprev<cr>zz") ]]
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Global change word" })
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Load packer
vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/cocobio/packer.lua<CR>");

-- Spliting screens
vim.keymap.set("n", "<leader>-", vim.cmd.split, { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>|", vim.cmd.vsplit, { desc = "Vertical split" })

-- Highlights in search
vim.keymap.set("n", "<leader>h", vim.cmd.nohlsearch, { desc = "No highlight search" })

vim.keymap.set("n", "<leader><leader>", vim.cmd.so, { desc = "Shoutout file" })
