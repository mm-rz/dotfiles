return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", 
		ensure_installed = {"lua", "markdown", "python", "markdown", "markdown_inline" },
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	}
}
