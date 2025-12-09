return {
  "olimorris/codecompanion.nvim",
  version = "v17.33.0",
  opts = {},
  config = function()
    local sensitive_filetypes = {
      gitcommit = true,
      NvimTree = true,
      help = true,
      man = true,
      oil = true,
      TelescopePrompt = true,
      sh = true,
    }

    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "copilot",
          model = "gpt-4.1",
          slash_commands = {
            ["file"] = {
              callback = require("codecompanion.strategies.chat.slash_commands").file,
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope",   -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                contains_code = true,
              },
            },
          },
        }
      },
      display = {
        diff = {
          enabled = true,
          provider_opts = {
            inline = {
              layout = "buffer",             -- float|buffer - Where to display the diff
              diff_edit = true,              -- Enable diff edit when using inline Assistant
              opts = {
                context_lines = 3,           -- Number of context lines in hunks
                dim = 25,                    -- Background dim level for floating diff (0-100, [100 full transparent], only applies when layout = "float")
                full_width_removed = true,   -- Make removed lines span full width
                show_keymap_hints = true,    -- Show "gda: accept | gdr: reject" hints above diff
                show_removed = true,         -- Show removed lines as virtual text
              },
            },
          },
        },
        chat = {
          window = {
            layout = "vertical",
            position = "right", -- open chat buffer on the right
            width = 0.27,
            sticky = false,
          },
        }
      }
    })

    -- Keymap to open chat buffer, but ignore for sensitive filetypes
    vim.keymap.set("n", "<leader>cc", function()
      local ft = vim.bo.filetype
      if sensitive_filetypes[ft] then
        vim.notify("CodeCompanion chat is disabled for this filetype: " .. ft, vim.log.levels.WARN)
        return
      end
      vim.cmd("CodeCompanionChat")
      -- require("codecompanion.chat").toggle()
    end, { desc = "Toggle CodeCompanion Chat" })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
