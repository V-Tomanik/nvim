-- FILE EXPLORER: mini.files (floating columns: parent | folder | preview)
--
--   Space e    open at the current file        Space E    open at the project root
--   l / Enter  go into folder / open file      h          back to parent
--   n          new file (end the name with / for a folder)
--   r          rename
--   dd         delete (asks first; goes to ~/.local/share/nvim/mini.files/trash)
--   m          move: press on the item, open the destination folder, press m again
--              (pressing m again in the same folder cancels)
--   q          close                           g?         help
--
-- n / r / dd / m act on the disk immediately. Plain text editing + `=` (mini.files'
-- original way) still works, but see the note in the README about renaming with `cc`.
do
  vim.pack.add { 'https://github.com/nvim-mini/mini.files' }
  local MiniFiles = require 'mini.files'
  local trash_dir = vim.fn.stdpath 'data' .. '/mini.files/trash'
  local WARN, ERROR = vim.log.levels.WARN, vim.log.levels.ERROR

  MiniFiles.setup {
    windows = { preview = true, width_preview = 40 },
    options = { permanent_delete = false },
    -- disable bookmarks so `m` is free for move
    mappings = { mark_set = '', mark_goto = '' },
  }

  local function notify(msg, level) vim.notify(msg, level or vim.log.levels.INFO, { title = 'Files' }) end
  local function exists(path) return vim.uv.fs_stat(path) ~= nil end
  local function confirm(question) return vim.fn.confirm(question, '&Yes\n&No', 2) == 1 end

  -- The folder shown in the focused column
  local function current_dir()
    local state = MiniFiles.get_explorer_state()
    return state and state.branch[state.depth_focus]
  end

  -- Re-read the disk into the explorer
  local function refresh() MiniFiles.synchronize() end

  -- Keep open buffers pointing at the file after it is renamed or moved
  local function follow_buffers(old, new)
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      local target = (name == old and new) or (vim.startswith(name, old .. '/') and new .. name:sub(#old + 1))
      if target and vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_set_name(buf, target)
        vim.api.nvim_buf_call(buf, function() vim.cmd 'silent! write!' end)
      end
    end
  end

  local function create()
    local dir = current_dir()
    if not dir then return end
    vim.ui.input({ prompt = 'New (end with / for a folder): ' }, function(input)
      if not input or input == '' then return end
      local path = vim.fs.joinpath(dir, input)
      if exists(path) then return notify(input .. ' already exists', WARN) end
      if input:sub(-1) == '/' then
        vim.fn.mkdir(path, 'p')
      else
        vim.fn.mkdir(vim.fs.dirname(path), 'p')
        vim.fn.writefile({}, path)
      end
      refresh()
    end)
  end

  local function rename()
    local entry = MiniFiles.get_fs_entry()
    if not entry then return end
    vim.ui.input({ prompt = 'Rename to: ', default = entry.name }, function(input)
      if not input or input == '' or input == entry.name then return end
      local new = vim.fs.joinpath(vim.fs.dirname(entry.path), input)
      -- macOS disks ignore case, so "notes.md" -> "Notes.md" must be allowed
      if exists(new) and input:lower() ~= entry.name:lower() then
        return notify(input .. ' already exists', WARN)
      end
      local ok, err = vim.uv.fs_rename(entry.path, new)
      if not ok then return notify('Rename failed: ' .. err, ERROR) end
      follow_buffers(entry.path, new)
      refresh()
    end)
  end

  local function delete()
    local entry = MiniFiles.get_fs_entry()
    if not entry then return end
    local kind = entry.fs_type == 'directory' and 'folder' or 'file'
    if not confirm(('Delete %s "%s"? (goes to trash)'):format(kind, entry.name)) then return end
    vim.fn.mkdir(trash_dir, 'p')
    local dest = vim.fs.joinpath(trash_dir, entry.name)
    if exists(dest) then vim.fn.delete(dest, 'rf') end -- trash keeps the latest copy of a name
    local ok, err = vim.uv.fs_rename(entry.path, dest)
    if not ok then return notify('Delete failed: ' .. err, ERROR) end
    refresh()
  end

  local move_src -- path waiting to be moved (set by the first `m`)
  local function move()
    if not move_src then
      local entry = MiniFiles.get_fs_entry()
      if not entry then return end
      move_src = entry.path
      return notify(('Moving "%s": open the destination folder and press m'):format(entry.name))
    end

    local src, dir = move_src, current_dir()
    move_src = nil
    if not dir or dir == vim.fs.dirname(src) then return notify 'Move cancelled' end
    if dir == src or vim.startswith(dir, src .. '/') then return notify('Cannot move a folder into itself', WARN) end
    local name = vim.fs.basename(src)
    local new = vim.fs.joinpath(dir, name)
    if exists(new) then return notify(name .. ' already exists in that folder', WARN) end
    if not confirm(('Move "%s" to %s?'):format(name, vim.fn.fnamemodify(dir, ':~:.'))) then
      return notify 'Move cancelled'
    end
    local ok, err = vim.uv.fs_rename(src, new)
    if not ok then return notify('Move failed: ' .. err, ERROR) end
    follow_buffers(src, new)
    refresh()
  end

  local group = vim.api.nvim_create_augroup('explorer', { clear = true })
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local function map(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { buffer = args.data.buf_id, nowait = true, desc = desc }) end
      map('n', create, 'New file / folder (end with /)')
      map('r', rename, 'Rename')
      map('dd', delete, 'Delete (to trash)')
      map('m', move, 'Move (m on item, then m in destination)')
    end,
  })
  -- closing the explorer forgets a half-finished move
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'MiniFilesExplorerClose',
    callback = function() move_src = nil end,
  })

  vim.keymap.set('n', '<leader>e', function()
    local file = vim.api.nvim_buf_get_name(0)
    -- open at the current file (or the project root for the start page / unnamed buffers)
    MiniFiles.open(vim.uv.fs_stat(file) and file or vim.uv.cwd(), false)
  end, { desc = '[E]xplore files' })
  vim.keymap.set('n', '<leader>E', function() MiniFiles.open(vim.uv.cwd(), false) end, { desc = '[E]xplore project root' })
end
