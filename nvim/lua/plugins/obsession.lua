-- Session.vim tracking, for tmux-resurrect.
--
-- tmux.conf sets @resurrect-strategy-nvim "session": when a pane running nvim is
-- restored, resurrect looks for Session.vim in that pane's directory and, if it
-- finds one, starts `nvim -S` so buffers, splits and cursor positions come back
-- instead of an empty editor.
--
-- Obsession keeps that file updated CONTINUOUSLY. An autocmd on VimLeavePre was
-- the obvious alternative, but it never fires on a reboot or a crash -- which is
-- precisely the case this exists for.
--
-- Usage: :Obsession once inside a project starts tracking it (and creates
-- Session.vim there). :Obsession! stops and deletes it. Worth adding Session.vim
-- to your global gitignore, since it lands in the working directory.
return {
  {
    "tpope/vim-obsession",
    cmd = { "Obsession" },
    keys = {
      { "<leader>oo", "<cmd>Obsession<cr>", desc = "Obsession: track session here" },
      { "<leader>oO", "<cmd>Obsession!<cr>", desc = "Obsession: stop tracking" },
    },
  },
}
