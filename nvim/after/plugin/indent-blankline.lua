vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
-- vim.opt.listchars:append "blankline:"

require("indent_blankline").setup {
    space_char_blankline = " ",
    indent_blankline_char = '',
    show_current_context = true,
    show_current_context_start = true,
}
