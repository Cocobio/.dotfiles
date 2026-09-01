-- Key moves for LazyVim's harpoon2 extra. The extra still owns the plugin, its
-- opts and its updates; only two of its keys move here.
--
-- Upstream puts the quick menu on <leader>h and the jumps on <leader>1..9,
-- which claims nine bare leader+number combinations. Both move under <leader>h
-- so the prefix is self-contained and the numbers stay free.
--
-- `{ lhs, false }` is how lazy.nvim drops an inherited key. A plain LIST is used
-- rather than a function because lazy concatenates key lists across specs, while
-- two competing functions would not merge predictably.
local keys = {
  { "<leader>h", false },
  {
    "<leader>hh",
    function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    desc = "Harpoon Quick Menu",
  },
}

for i = 1, 9 do
  keys[#keys + 1] = { "<leader>" .. i, false }
  keys[#keys + 1] = {
    "<leader>h" .. i,
    function()
      require("harpoon"):list():select(i)
    end,
    desc = "Harpoon to File " .. i,
  }
end

return {
  { "ThePrimeagen/harpoon", keys = keys },
  { "folke/which-key.nvim", opts = { spec = { { "<leader>h", group = "harpoon" } } } },
}
