-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
vim.filetype.add {
  -- extension = {
  --   foo = "fooscript",
  -- },
  -- filename = {
  --   ["Foofile"] = "fooscript",
  -- },
  -- pattern = {
  --   ["~/%.config/foo/.*"] = "fooscript",
  -- },
}

-- Trying to keep the neovide rememeber window size setting
if vim.g.neovide then vim.g.neovide_remember_window_size = true end

-- Remove trailing whitespace on save... so not to dependend on linting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*", -- run on all filetypes
  command = [[%s/\s\+$//e]], -- remove trailing whitespace
  desc = "remove trailing whitespace",
})

-- Set up spec opener for Ruby files
local setup_spec_opener = function()
  vim.keymap.set("n", "<leader>t", function()
    local current_file = vim.fn.expand "%:p"
    local corresponding_file

    -- Detect if it's a source or test file
    if current_file:match "_spec%." then
      corresponding_file = current_file:gsub("spec/", "app/"):gsub("spec/lib/", "lib/"):gsub("_spec%.", ".")
    else
      corresponding_file = current_file:gsub("app/", "spec/"):gsub("lib/", "spec/lib/"):gsub("%.%w+$", "_spec%0")
    end

    vim.cmd("edit " .. corresponding_file)
  end, { desc = "Spec opener" })
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = setup_spec_opener,
  desc = "Setup spec opener",
})

-- Set up Telescope live grep for selected word: better <leader>fc from astro
vim.keymap.set("v", "<leader>f", function()
  vim.api.nvim_input "y"
  vim.api.nvim_input "<cmd> Telescope live_grep <CR>"
  vim.api.nvim_input "<c-r>"
  vim.api.nvim_input "0"
end, { desc = "Telescope live grep for selection" })
