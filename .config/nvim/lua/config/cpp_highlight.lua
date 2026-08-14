local M = {}

function M.setup()
  -- C++ LSP semantic tokens を現在のテーマの既存グループに寄せる

  -- 関数・メソッド
  vim.api.nvim_set_hl(0, "@lsp.type.function.cpp", { link = "Function" })
  vim.api.nvim_set_hl(0, "@lsp.type.method.cpp", { link = "Function" })

  -- 型
  vim.api.nvim_set_hl(0, "@lsp.type.class.cpp", { link = "Type" })
  vim.api.nvim_set_hl(0, "@lsp.type.struct.cpp", { link = "Type" })
  vim.api.nvim_set_hl(0, "@lsp.type.enum.cpp", { link = "Type" })
  vim.api.nvim_set_hl(0, "@lsp.type.type.cpp", { link = "Type" })
  vim.api.nvim_set_hl(0, "@lsp.type.typeParameter.cpp", { link = "Type" })

  -- namespace / macro
  vim.api.nvim_set_hl(0, "@lsp.type.namespace.cpp", { link = "Include" })
  vim.api.nvim_set_hl(0, "@lsp.type.macro.cpp", { link = "Macro" })

  -- 変数・引数・メンバ変数
  vim.api.nvim_set_hl(0, "@lsp.type.variable.cpp", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@lsp.type.parameter.cpp", { link = "Identifier" })
  vim.api.nvim_set_hl(0, "@lsp.type.property.cpp", { link = "Identifier" })

  -- enum member / 定数っぽいもの
  vim.api.nvim_set_hl(0, "@lsp.type.enumMember.cpp", { link = "Constant" })

  -- modifier
  vim.api.nvim_set_hl(0, "@lsp.mod.readonly.cpp", { link = "Constant" })
  vim.api.nvim_set_hl(0, "@lsp.mod.static.cpp", { link = "StorageClass" })
  vim.api.nvim_set_hl(0, "@lsp.mod.deprecated.cpp", { strikethrough = true })
end

return M
