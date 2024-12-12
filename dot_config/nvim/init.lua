require 'core' -- Load general options

-- -- Install package manager
-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system {
--     'git',
--     'clone',
--     '--filter=blob:none',
--     'https://github.com/folke/lazy.nvim.git',
--     '--branch=stable', -- latest stable release
--     lazypath,
--   }
-- end
-- vim.opt.rtp:prepend(lazypath)

-- -- Import color theme based on environment variable NVIM_THEME
-- local default_color_scheme = 'gruvbox_material'
-- local env_var_nvim_theme = os.getenv 'NVIM_THEME' or default_color_scheme

-- -- Setup plugins
-- require('lazy').setup({
--   ui = {
--     -- If you have a Nerd Font, set icons to an empty table which will use the
--     -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
--     icons = vim.g.have_nerd_font and {} or {
--       cmd = '⌘',
--       config = '🛠',
--       event = '📅',
--       ft = '📂',
--       init = '⚙',
--       keys = '🗝',
--       plugin = '🔌',
--       runtime = '💻',
--       require = '🌙',
--       source = '📄',
--       start = '🚀',
--       task = '📌',
--       lazy = '💤 ',
--     },
--   },
-- })

-- -- Function to check if a file exists
-- local function file_exists(file)
--   local f = io.open(file, 'r')
--   if f then
--     f:close()
--     return true
--   else
--     return false
--   end
-- end

-- -- Path to the session file
-- local session_file = '.session.vim'

-- -- Check if the session file exists in the current directory
-- if file_exists(session_file) then
--   -- Source the session file
--   vim.cmd('source ' .. session_file)
-- end

-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et