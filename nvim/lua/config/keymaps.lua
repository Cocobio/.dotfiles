-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Tab / Shift+Tab indent a visual selection, and keep it selected (gv) so the
-- keys repeat instead of having to reselect after every press.
--
-- Mapped in "x" (visual) deliberately, NOT "v": "v" is visual *and select* mode,
-- and in select mode Tab belongs to snippet jumping (blink.cmp / LuaSnip).
-- Taking it there would break tabbing between snippet placeholders.
vim.keymap.set("x", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "Dedent selection" })

-- Carried over from the old packer config. Both keys are free in LazyVim:
-- <leader>p appears only in the yanky extra and <leader>d only as a which-key
-- group label for debug, and neither extra is enabled (lazyvim.json: extras []).
-- If dap is ever enabled, <leader>d will want moving.
--
-- Deliberately NOT carried over: <leader>y / <leader>Y ("+y). LazyVim already
-- sets clipboard=unnamedplus off-SSH, so a plain y goes to the system clipboard
-- through wl-copy, with no OSC 52 and no kitty permission prompt.
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over selection (keep register)" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

