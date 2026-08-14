return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--header-insertion=iwyu",
        },
        filetypes = { "c", "cpp" },
      })

      vim.lsp.enable("clangd")
    end,
  },
}
