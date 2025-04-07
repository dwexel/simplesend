if not pcall(require, 'nvim-treesitter') then
    print("error, nvim-treesitter isn't available... standard treesitter grammars are not available")
    error("e")
end




-- will this error if grammars aren't installed
-- yes
-- wrap this in a check to which grammars are installed
-- local queries = {}
--     queries.r = vim.treesitter.query.parse("r", "(program [(call) (identifier) (binary_operator)] @to-send)")
--     queries.lua = vim.treesitter.query.parse("lua", "(chunk [(function_call) (variable_declaration) (assignment_statement) (function_declaration)] @to-send)")
--     queries.julia = vim.treesitter.query.parse("julia", "(source_file [(assignment) (macrocall_expression) (identifier)] @to-send)")
--
--

-- hmm
local queries = require("languages")

local M = {}

-- buf numbers
M.bufnrs = {}

-- session?
M.session = false


local send = function()
    -- 0 always represents the current buffer
	-- this will get the bufnr of the current buffer though
    --
    local bufnr = vim.fn.bufnr("%")
    -- local firsttime = false

		--   if not M.bufnrs[bufnr] then
		-- M.bufnr_s[bufnr] = true
		--
		-- firsttime = true
		-- -- vim.print("yeah")
		--   end

    local parser = vim.treesitter.get_parser(bufnr)


    if not parser then
		-- output error?
        vim.print("no tree-sitter grammar for current buffer. is it installed?")
		return
    end

    local filetype = vim.opt.filetype:get()
    local query = queries[filetype]

    if not query then
		-- how to write a 
	   -- vim error?
	   -- no support for this lang yet
		vim.print("we have no scm for filetype="..filetype)
		return
    end

    -- check whether this filetype has been setup yet and if not call back to 'setup'
    -- local did_setup = 

    local tree = vim.treesitter.get_node()
    if not tree then 
		-- file not yet saved?
		vim.print("no tree?")
    end

    local line = vim.fn.line(".") - 1
    local break_next

    for id, node, metadata, match in query:iter_captures(tree:root(), bufnr) do
    	-- += 1
    	local row1, col1, row2, col2 = node:range()

    	if break_next then
    	    vim.fn.cursor(row1 + 1, col1)
    	    break
    	end

    	if line >= row1 and line <= row2 then
    	    local text = vim.treesitter.get_node_text(node, bufnr)

			-- the point is that if this is the first time a buffer is being used 
			-- then a callback is run in which we say what to do
			-- if firsttime then
			-- 	M.opts.setup()
			-- end

			if M.opts.register then
				vim.fn.setreg(M.opts.register, text)
			end

			if M.opts.each_session and not M.session then
				m.opts.each_session()
			end

			if M.opts.each_buffer and not M.bufnrs[bufnr] then
				M.bufnrs[bufnr] = true
				M.opts.each_buffer(filetype, text)
			end

			-- each expression
			-- pcall?
			if M.opts.each_expression then
				M.opts.each_expression(text)
    	    -- if M.opts.callback then
    	       -- M.opts.callback(text)
    	    end

    	    break_next = true
    	end
    end
end

function M.setup(opts)
    -- lazy loading?
    -- load on event?
    -- load on filetype?
    -- load on keypress?
    -- load on command?
    --
    -- dependencies?
    --
    --

    --
    --
  -- M.opts = vim.tbl_deep_extend('force', default_config, opts or {})

    -- also let set a command that takes input
    -- or a shell command
    -- or a string

    M.opts = opts or {}

    if not M.opts.key then 
		M.opts.key = "MM"
    end


	-- don't worry about this right now
	
    -- if not M.opts.callback then
	-- if not M.opts.each_
	--
	-- 	-- mutually exclusive
	-- 	if M.opts.system then
	--
	-- 		local i_placeholder
	--
	-- 		-- find the index that's a placeholder
	-- 		for i, v in ipairs(M.opts.system) do
	-- 			if v == "$" or v == {} then
	-- 				i_placeholder = i
	-- 			end
	-- 		end
	--
	-- 		-- create the missing callback
	-- 		M.opts.callback = function(text)
	-- 		M.opts.system[i_placeholder] = text
	-- 		vim.print(M.opts.system)
	--
	-- 		local success, message = pcall(vim.system, M.opts.system)
	--
	-- 		-- print(message)
	-- 		end
	-- 	end
	--    end

    -- register a register
    if not M.opts.register then
		M.opts.register = [[m]]
    end

	-- create a keymap for the main function
    vim.keymap.set('n', M.opts.key, send, {desc = "Send top-level expression to given callback"})

	-- create a user Command for the main function
    vim.api.nvim_create_user_command('Send', send, {desc = "Send top-level expression to given callback"})

	M.did_setup = true
end

return M
