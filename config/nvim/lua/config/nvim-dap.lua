ret = {}

ret.config = function()
	local dap = require("dap")

	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = {"--interpreter=dap", "--eval-command", "set print pretty on"}
	}

	dap.configurations.c = {
		{
			name = 'Attach to gdbserver :3020',
			type = 'gdb',
			request = 'attach',
			target = 'localhost:3020',
			program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = '${workspaceFolder}'
		},
	}
end

return ret
