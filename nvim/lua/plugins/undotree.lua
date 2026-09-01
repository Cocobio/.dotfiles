-- Undo history as a navigable tree, carried over from the old packer config
-- (where it was <leader>u, which LazyVim now uses as its UI-toggle prefix).
-- <leader>uu is free: LazyVim maps 32 keys under <leader>u, but not that one.
return {
  "mbbill/undotree",
  keys = {
    { "<leader>uu", vim.cmd.UndotreeToggle, desc = "Undotree" },
  },
}
