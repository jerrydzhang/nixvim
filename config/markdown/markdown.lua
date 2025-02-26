vim.opt.spell = true          -- Turn on spell checking
vim.opt.spelllang = { 'en_us' } -- Set the spell checking language (e.g., English)

_G.enable_auto_open = _G.enable_auto_open or false
vim.api.nvim_create_augroup("Markdown", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = "Markdown",
	callback = function()
		if _G.enable_auto_open then
			vim.cmd("ObsidianOpen")
		end
	end,
})

local hydra = require("hydra")
hydra({
	name = "ObsidianNavigator",
	config = {
		color = 'teal',
	},
	mode = { "n", "v" },
	body = "<localleader>o",
	heads = {
		{ "d", ":ObsidianDailies<CR>" },
		{ "s", ":ObsidianQuickSwitch<CR>" },
		{ "o", ":ObsidianOpen<CR>" },
		{ "n", ":ObsidianNew<CR>" },
		{ "t", ":ObsidianTemplate<CR>" },
		{ "h", ":ObsidianOpen Home<CR>" },
		{ "x", ":ObsidianExtractNote<CR>" },
		{ "a", function()
			_G.enable_auto_open = not _G.enable_auto_open
			print("Auto open is now " .. tostring(_G.enable_auto_open))
		end },
		{ "<esc>", nil, { exit = true } },
		{ "q", nil, { exit = true } },
	},
})
