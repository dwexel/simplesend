local queries = {}

queries.r = vim.treesitter.query.parse("r", "(program [(call) (identifier) (binary_operator)] @to-send)")
queries.lua = vim.treesitter.query.parse("lua", "(chunk [(function_call) (variable_declaration) (assignment_statement) (function_declaration)] @to-send)")
queries.julia = vim.treesitter.query.parse("julia", "(source_file [(assignment) (macrocall_expression) (identifier)] @to-send)")

return queries
