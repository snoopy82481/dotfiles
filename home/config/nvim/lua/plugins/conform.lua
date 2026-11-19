return {
  'stevearc/conform.nvim',
  event = { "BufReadPre" },
  cmd = { "ConformInfo", "ConformFormat", "Reformat" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "eslint_d" },
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
    },
    default_format_opts = {
      lsp_format = "never",
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
