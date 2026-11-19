-- Custom code snippets for different purposes

-- Prevent LSP from overwriting treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.hl.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level

-- Appearance of diagnostics
vim.diagnostic.config {
  virtual_text = {
    prefix = '●',
    -- Add a custom format function to show error codes
    format = function(diagnostic)
      local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
      return string.format('%s %s', code, diagnostic.message)
    end,
  },
  underline = false,
  update_in_insert = true,
  float = {
    source = 'always', -- Or "if_many"
  },
}

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set kitty terminal padding to 0 when in nvim
if vim.env.KITTY_WINDOW_ID and vim.fn.executable 'kitty' == 1 then
vim.cmd [[
  augroup kitty_mp
  autocmd!
  au VimLeave * :silent !kitty @ set-spacing padding=default margin=default
  au VimEnter * :silent !kitty @ set-spacing padding=0 margin=0 3 0 3
  augroup END
]]
end

local function diagnostic_backgrounds()
  for _, severity in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
    local name = 'DiagnosticVirtualText' .. severity
    local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
    highlight.bg = nil
    vim.api.nvim_set_hl(0, name, highlight)
  end
end
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('DiagnosticBackgrounds', { clear = true }),
  callback = diagnostic_backgrounds,
})
diagnostic_backgrounds()
