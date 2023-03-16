local dap = require("dap")

dap.adapters.coreclr = {
	type = "executable",
	command = "/usr/local/netcoredbg/netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		name = "Launch",
		type = "coreclr",
		request = "launch",
		program = function()
			local file_name = vim.fn.input("Program Name: ", "")

			return "${workspaceFolder}/bin/Debug/net7.0/" .. file_name
		end,
		args = {},
		preLaunchTask = "build",
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
	},
}
