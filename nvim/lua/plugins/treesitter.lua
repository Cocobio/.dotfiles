-- render-markdown (from the lang.markdown extra) renders LaTeX formulas only if
-- the `latex` parser is present -- it is not one of LazyVim's defaults, and
-- without it math blocks stay as raw $$...$$.
return {
  "nvim-treesitter/nvim-treesitter",
  opts = { ensure_installed = { "latex" } },
}
