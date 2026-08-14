vim.loader.enable()
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true

require("lazy").setup("plugins", {})
		
vim.opt.clipboard:append({"unnamedplus"})

local function apply_cpp_highlight()
  require("config.cpp_highlight").setup()
end

apply_cpp_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_cpp_highlight,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
