return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    local treesitter = require 'nvim-treesitter'
    treesitter.setup { install_dir = vim.fn.stdpath 'data' .. '/treesitter' }

    local languages = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
    }
    local available = {}
    for _, language in ipairs(treesitter.get_available()) do
      available[language] = true
    end

    vim.filetype.add {
      extension = { tf = 'terraform', tfvars = 'terraform', pipeline = 'groovy', multibranch = 'groovy' },
    }

    local requested = {}
    local function attach(buf)
      if not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].buftype ~= '' then
        return
      end
      local language = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if not language or not available[language] then
        return
      end
      if not vim.treesitter.language.add(language) then
        if requested[language] then
          return
        end
        requested[language] = true
        treesitter.install({ language }):await(function(err, success)
          if not err and success then
            vim.schedule(function()
              attach(buf)
            end)
          end
        end)
        return
      end
      if vim.bo[buf].filetype ~= 'just' then
        vim.treesitter.start(buf, language)
      end
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      require('core.treesitter-selection').attach(buf)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterAttach', { clear = true }),
      callback = function(event)
        attach(event.buf)
      end,
    })
    treesitter.install(languages, { max_jobs = 2 }):await(function(err, success)
      if not err and success then
        vim.schedule(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            attach(buf)
          end
        end)
      end
    end)

    require('nvim-treesitter-textobjects').setup {
      select = { lookahead = true },
      move = { set_jumps = true },
    }
    for key, capture in pairs {
      aa = '@parameter.outer',
      ia = '@parameter.inner',
      af = '@function.outer',
      ['if'] = '@function.inner',
      ac = '@class.outer',
      ic = '@class.inner',
    } do
      vim.keymap.set({ 'x', 'o' }, key, function()
        require('nvim-treesitter-textobjects.select').select_textobject(capture, 'textobjects')
      end)
    end
    local movements = {
      { ']m', 'goto_next_start', '@function.outer' },
      { ']]', 'goto_next_start', '@class.outer' },
      { ']M', 'goto_next_end', '@function.outer' },
      { '][', 'goto_next_end', '@class.outer' },
      { '[m', 'goto_previous_start', '@function.outer' },
      { '[[', 'goto_previous_start', '@class.outer' },
      { '[M', 'goto_previous_end', '@function.outer' },
      { '[]', 'goto_previous_end', '@class.outer' },
    }
    local function map_movements(buf)
      for _, movement in ipairs(movements) do
        vim.keymap.set({ 'n', 'x', 'o' }, movement[1], function()
          require('nvim-treesitter-textobjects.move')[movement[2]](movement[3], 'textobjects')
        end, { buffer = buf })
      end
    end
    -- Filetype plugins can define buffer-local motions after global mappings.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterMotions', { clear = true }),
      callback = function(event)
        map_movements(event.buf)
      end,
    })
    for _, direction in ipairs { 'next', 'previous' } do
      vim.keymap.set('n', direction == 'next' and '<leader>a' or '<leader>A', function()
        require('nvim-treesitter-textobjects.swap')['swap_' .. direction] '@parameter.inner'
      end)
    end
  end,
}
