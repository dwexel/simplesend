# simplesend
neovim, barebones plugin; send top-level expressions to another program, using tree-sitter

```lua
require("simplesend").setup({
    key = "MM",

    -- should check and make sure treesitter is parsing on every insertion, not just on file save
    --
    -- callback = vim.print,

	-- each session, each buffer, each expression

	
	-- rename: first_call
	--
    each_buffer = function(filetype)
		vim.print("this is just yeah as it is")
    end,

	-- rename: every_call
    each_expression = function(text)
		local success, message = pcall(vim.system, {'wezterm', 'cli', 'send-text', '--pane-id', '1', '--no-paste', text..'\r'})
		-- local success, message = pcall(vim.system, {'wezterm', 'cli', 'send-text', '--pane-id', '0', '--no-paste', text..'\r'})
		if not success then
			vim.print(message)
		else
			-- vim.print("suck sess")
		end
    end
})
```
