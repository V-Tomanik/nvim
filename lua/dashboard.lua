-- START PAGE: a keymap cheat sheet shown when you run `nvim` with no file.
-- Edit the `sections` table below to change what's shown.
-- Keys on this page: f files · r recent · g grep · n new file · c config · q quit
do
  -- { key, description } rows grouped in sections. Left and right columns.
  local left = {
    { 'FILES & SEARCH' },
    { 'Space sf', 'find file' },
    { 'Space sg', 'grep text in project' },
    { 'Space s.', 'recent files' },
    { 'Space Space', 'open buffers' },
    { '-', 'file explorer (edit, then :w)' },
    { 'Ctrl+h/j/k/l', 'move between splits / tmux panes' },
    {},
    { 'CODE' },
    { 'grd / grr', 'definition / references' },
    { 'grn / gra', 'rename / code action' },
    { 'K', 'hover docs' },
    { '[d / ]d', 'prev / next diagnostic' },
    { 'Ctrl+Space', 'completion (Ctrl+y accepts)' },
    { 'Space f', 'format' },
    { 'Space tf', 'toggle format on save' },
  }
  local right = {
    { 'SAVE & QUIT' },
    { ':w  or  Space w', 'save' },
    { ':wq  or  ZZ', 'save and quit' },
    { ':q!', 'quit without saving' },
    { 'u / Ctrl+r', 'undo / redo' },
    {},
    { 'GIT' },
    { 'Space gg', 'lazygit' },
    { ']c / [c', 'next / prev change' },
    { 'Space hs / hr', 'stage / reset hunk' },
    { 'Space hp', 'preview hunk' },
    {},
    { 'TMUX  (prefix = Ctrl+a)' },
    { 'Ctrl+h/j/k/l', 'move between panes' },
    { 'prefix | / -', 'split side / stacked' },
    { 'prefix z / x', 'zoom / close pane' },
    { 'prefix c / s', 'new window / sessions' },
    { 'prefix d', 'detach (keeps running)' },
  }
  local footer = 'Press Space and wait: which-key lists everything · Space sk searches all keymaps'
  local actions = {
    { 'f', 'Find file', function() require('telescope.builtin').find_files() end },
    { 'r', 'Recent', function() require('telescope.builtin').oldfiles() end },
    { 'g', 'Grep', function() require('telescope.builtin').live_grep() end },
    { 'n', 'New file', function() vim.cmd 'enew' end },
    { 'c', 'Config', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end },
    { 'q', 'Quit', function() vim.cmd 'qa' end },
  }

  local KEY_W, DESC_W, GAP = 18, 30, 4
  local COL_W = KEY_W + DESC_W

  -- Render one row: returns text plus highlight ranges {group, start, end} (byte columns)
  local function row(item)
    if not item[1] then return '', {} end
    if not item[2] then return item[1], { { 'Title', 0, #item[1] } } end
    local key = item[1] .. string.rep(' ', KEY_W - vim.fn.strdisplaywidth(item[1]))
    local text = key .. item[2]
    return text, { { 'Special', 0, #item[1] }, { 'Comment', #key, #text } }
  end

  local function pad(text, width) return text .. string.rep(' ', width - vim.fn.strdisplaywidth(text)) end

  local function build(width)
    local lines, hls = {}, {}
    local function add(text, ranges)
      table.insert(lines, text)
      for _, r in ipairs(ranges or {}) do table.insert(hls, { #lines - 1, r[1], r[2], r[3] }) end
    end

    local header = 'N E O V I M'
    add(header, { { 'Title', 0, #header } })
    add ''

    -- action bar (two rows in narrow windows)
    local per_row = width < 90 and 3 or #actions
    for first = 1, #actions, per_row do
      local bar, bar_hls = '', {}
      for i = first, math.min(first + per_row - 1, #actions) do
        local a = actions[i]
        if bar ~= '' then bar = bar .. '    ' end
        table.insert(bar_hls, { 'Special', #bar, #bar + 3 })
        bar = bar .. ('[%s] %s'):format(a[1], a[2])
      end
      add(bar, bar_hls)
    end
    add ''

    if width >= COL_W * 2 + GAP then
      for i = 1, math.max(#left, #right) do
        local lt, lh = row(left[i] or {})
        local rt, rh = row(right[i] or {})
        local lpad = pad(lt, COL_W + GAP)
        local offset = #lpad
        for _, r in ipairs(rh) do table.insert(lh, { r[1], r[2] + offset, r[3] + offset }) end
        add(lpad .. rt, lh)
      end
    else -- narrow window: one column
      for _, item in ipairs(left) do add(row(item)) end
      add ''
      for _, item in ipairs(right) do add(row(item)) end
    end
    add ''
    add(footer, { { 'NonText', 0, #footer } })
    return lines, hls
  end

  local ns = vim.api.nvim_create_namespace 'dashboard'

  local function render(buf, win)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
    local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
    local lines, hls = build(width)

    -- centre the block: same left margin for every line, vertical padding on top
    local block_w = 0
    for _, l in ipairs(lines) do block_w = math.max(block_w, vim.fn.strdisplaywidth(l)) end
    local margin = math.max(0, math.floor((width - block_w) / 2))
    local top = math.max(0, math.floor((height - #lines) / 2))
    local indent = string.rep(' ', margin)

    local out = {}
    for _ = 1, top do table.insert(out, '') end
    for _, l in ipairs(lines) do table.insert(out, l == '' and '' or indent .. l) end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for _, h in ipairs(hls) do
      local lnum, group, s, e = h[1] + top, h[2], h[3] + margin, h[4] + margin
      pcall(vim.api.nvim_buf_set_extmark, buf, ns, lnum, s, { end_col = e, hl_group = group })
    end
  end

  local function open()
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = 'dashboard'
    vim.wo[win][0].number = false
    vim.wo[win][0].relativenumber = false
    vim.wo[win][0].cursorline = false
    vim.wo[win][0].signcolumn = 'no'
    vim.wo[win][0].list = false
    vim.wo[win][0].wrap = false

    render(buf, win)

    for _, a in ipairs(actions) do
      vim.keymap.set('n', a[1], a[3], { buffer = buf, nowait = true, desc = 'Dashboard: ' .. a[2] })
    end
    vim.api.nvim_create_autocmd('VimResized', {
      buffer = buf,
      callback = function() render(buf, vim.fn.bufwinid(buf)) end,
    })
  end

  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('dashboard', { clear = true }),
    callback = function()
      -- only for a bare `nvim`: no files, no piped stdin, empty unnamed buffer
      if vim.fn.argc() > 0 or vim.fn.line2byte('$') ~= -1 or vim.api.nvim_buf_get_name(0) ~= '' then return end
      if vim.g.started_with_stdin then return end
      open()
    end,
  })
  vim.api.nvim_create_autocmd('StdinReadPre', { callback = function() vim.g.started_with_stdin = true end })

  vim.api.nvim_create_user_command('Dashboard', function()
    vim.cmd 'enew'
    open()
  end, { desc = 'Open the start page' })
end
