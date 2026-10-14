return {
  "coder/claudecode.nvim",
  init = function()
    -- The plugin's default diff colors are hardcoded for dark themes; follow the colorscheme instead.
    local function link_diff_highlights()
      vim.api.nvim_set_hl(0, "ClaudeCodeInlineDiffAdd", { link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "ClaudeCodeInlineDiffDelete", { link = "DiffDelete" })
    end
    link_diff_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = link_diff_highlights })

    -- The diff splits the editor window in half; give it most of the screen instead.
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffOpened",
      callback = function(event)
        vim.api.nvim_win_set_width(event.data.diff_window, math.floor(vim.o.columns * 0.55))
      end,
    })

    -- ClaudeCodeOpen, not ClaudeCodeFocus: Focus hides the terminal when it already has focus.
    vim.api.nvim_create_autocmd("User", {
      pattern = "ClaudeCodeDiffClosed",
      callback = function()
        vim.schedule(function()
          vim.cmd("ClaudeCodeOpen")
        end)
      end,
    })
  end,
  opts = {
    terminal = {
      -- Snacks paints its windows with NormalFloat; use the editor background instead.
      snacks_win_opts = { wo = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
    },
    diff_opts = {
      layout = "unified",
    },
  },
}
