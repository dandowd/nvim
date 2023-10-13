local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions

vim.keymap.set("n", "<leader>ff", function() builtin.find_files({ hidden = true }) end, {})
vim.keymap.set("n", "<leader>fp", extensions.projects.projects, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fr", builtin.registers, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
  { noremap = true }
)
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argv(0) == "" then
      require("telescope.builtin").find_files()
    end
  end,
})
