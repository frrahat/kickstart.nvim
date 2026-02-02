-- Custom inline plugin to copy Git URLs for selected lines
return {
  {
    'folke/snacks.nvim', -- Attach to an existing plugin
    optional = true,
    init = function()
      -- Shared function to copy git URL
      local function copy_git_url(start_line, end_line)
        -- Get current file path
        local file_path = vim.fn.expand '%:p'

        -- Check if file exists
        if file_path == '' then
          vim.notify('No file open', vim.log.levels.ERROR)
          return
        end

        -- Function to get git remote URL
        local function get_git_remote_url()
          local handle = io.popen 'git config --get remote.newscred.url 2>/dev/null'
          if not handle then return nil end
          local result = handle:read '*a'
          handle:close()

          if result == '' then return nil end

          -- Clean up the URL
          result = result:gsub('\n', '')

          -- Convert SSH URL to HTTPS
          if result:match '^git@' then result = result:gsub('^git@([^:]+):', 'https://%1/') end

          -- Remove .git suffix
          result = result:gsub('%.git$', '')

          return result
        end

        -- Function to get commit hash from master or main branch
        local function get_git_ref()
          -- Try master first
          local handle = io.popen 'git rev-parse newscred/master 2>/dev/null'
          if handle then
            local commit = handle:read('*a'):gsub('\n', '')
            handle:close()
            if commit ~= '' then return commit end
          end

          -- Try main if master doesn't exist
          handle = io.popen 'git rev-parse newscred/main 2>/dev/null'
          if handle then
            local commit = handle:read('*a'):gsub('\n', '')
            handle:close()
            if commit ~= '' then return commit end
          end

          return nil
        end

        -- Function to get repository root
        local function get_git_root()
          local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
          if not handle then return nil end
          local root = handle:read('*a'):gsub('\n', '')
          handle:close()

          if root == '' then return nil end

          return root
        end

        -- Get git root
        local git_root = get_git_root()
        if not git_root then
          vim.notify('Not in a git repository', vim.log.levels.ERROR)
          return
        end

        -- Get relative path from git root
        local relative_path = file_path:sub(#git_root + 2) -- +2 to remove leading slash

        -- Get remote URL
        local remote_url = get_git_remote_url()
        if not remote_url then
          vim.notify('No git remote found', vim.log.levels.ERROR)
          return
        end

        -- Get git ref (branch or commit)
        local git_ref = get_git_ref()
        if not git_ref then
          vim.notify('Could not determine git ref', vim.log.levels.ERROR)
          return
        end

        -- Construct GitHub URL
        local url
        if start_line == end_line then
          url = string.format('%s/blob/%s/%s#L%d', remote_url, git_ref, relative_path, start_line)
        else
          url = string.format('%s/blob/%s/%s#L%d-L%d', remote_url, git_ref, relative_path, start_line, end_line)
        end

        -- Copy to clipboard
        vim.fn.setreg('+', url)
        vim.notify('Copied: ' .. url, vim.log.levels.INFO)
      end

      -- Normal mode keymap - current line
      vim.keymap.set('n', '<leader>gy', function()
        local current_line = vim.fn.line '.'
        copy_git_url(current_line, current_line)
      end, { desc = 'Copy git URL for current line' })

      -- Visual mode keymap - selected range
      vim.keymap.set('v', '<leader>gy', function()
        local start_line = vim.fn.line 'v'
        local end_line = vim.fn.line '.'
        -- Ensure start is before end
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        copy_git_url(start_line, end_line)
      end, { desc = 'Copy git URL for selected lines' })
    end,
  },
}
