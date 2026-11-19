local M = {}

function M.attach(buf)
  local history = {}
  local tick

  local function select_node(node)
    local sr, sc, er, ec = node:range()
    if ec == 0 and er > sr then
      er = er - 1
      ec = #vim.api.nvim_buf_get_lines(buf, er, er + 1, false)[1]
    end
    if vim.fn.mode():match '[vV\22]' then
      vim.cmd.normal { '\27', bang = true }
    end
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd.normal { 'v', bang = true }
    vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
  end

  local function grow(scope)
    if tick ~= vim.api.nvim_buf_get_changedtick(buf) or vim.fn.mode() == 'n' then
      history = {}
    end
    tick = vim.api.nvim_buf_get_changedtick(buf)
    local node = history[#history]
    if not node then
      local parser = vim.treesitter.get_parser(buf)
      if not parser then
        return
      end
      parser:parse()
      node = vim.treesitter.get_node { bufnr = buf }
    else
      local previous = node
      node = node:parent()
      while node and vim.deep_equal({ node:range() }, { previous:range() }) do
        node = node:parent()
      end
      if scope and node then
        local language = vim.treesitter.get_parser(buf):lang()
        local query = vim.treesitter.query.get(language, 'locals')
        local scopes = {}
        if query then
          local root = vim.treesitter.get_parser(buf):parse()[1]:root()
          for id, capture in query:iter_captures(root, buf, 0, -1) do
            if query.captures[id] == 'local.scope' then
              scopes[capture:id()] = true
            end
          end
        end
        while node and not scopes[node:id()] do
          node = node:parent()
        end
      end
    end
    if node then
      history[#history + 1] = node
      select_node(node)
    end
  end

  vim.keymap.set({ 'n', 'x' }, '<C-Space>', function()
    grow(false)
  end, { buffer = buf })
  vim.keymap.set('x', '<C-s>', function()
    grow(true)
  end, { buffer = buf })
  vim.keymap.set('x', '<M-Space>', function()
    if tick ~= vim.api.nvim_buf_get_changedtick(buf) or #history < 2 then
      return
    end
    table.remove(history)
    select_node(history[#history])
  end, { buffer = buf })
end

return M
