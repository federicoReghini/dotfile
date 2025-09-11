local prompts = {
  -- Code related prompts
  Explain = "Please explain how the following code works.",
  Review = "Please review the following code and provide suggestions for improvement.",
  Tests = "Please explain how the selected code works, then generate unit tests for it.",
  Refactor = "Please refactor the following code to improve its clarity and readability.",
  FixCode = "Please fix the following code to make it work as intended.",
  FixError = "Please explain the error in the following text and provide a solution.",
  BetterNamings = "Please provide better names for the following variables and functions.",
  Documentation = "Please provide documentation for the following code.",
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  -- Text related prompts
  Summarize = "Please summarize the following text.",
  Spelling = "Please correct any grammar and spelling errors in the following text.",
  Wording = "Please improve the grammar and wording of the following text.",
  Concise = "Please rewrite the following text to make it more concise.",
  Commit = {
    prompt = "Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters. Format as a gitcommit code block.",
    context = { "git:staged", "buffer" },
    model = "gpt-4o",
  },
  ReactDesignPattern = {
    prompt = "Analyze the following code and suggest the most suitable React Design Pattern, Best practice to improve its structure and maintainability. Provide a brief explanation of why this pattern is appropriate or why the current approach is effective. Focus on best practices, scalability and performance. If the code is already well-structured, simply state that no changes are necessary and explain why.",
    system_prompt = "You are a Senior React, React Native developer with over 10 years of experience. You know everything about Design Patterns, Clean Code, Refactoring, and best practices all by using TYPESCRIPT",
    context = { "buffers", "git:diff" },
  },
}

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    { "nvim-telescope/telescope.nvim" }, -- Use telescope for help actions
  },
  build = "make tiktoken", -- Only on MacOS or Linux
  opts = {
    debug = true, -- Enable debugging
    question_header = "## Fede ",
    model = "claude-sonnet-4",
    temperature = 0.2,
    sticky = {
      "@models Using claude-sonnet-4",
      "#buffers",
    },

    -- See Configuration section for rest
    window = {
      layout = "vertical",
      relative = "editor",
    },

    prompts = prompts,
    -- Uses visual selection or falls back to buffer
    selection = function(source)
      local select = require("CopilotChat.select")
      return select.visual(source) or select.buffer(source)
    end,
  },
  config = function(_, opts)
    local chat = require("CopilotChat")
    chat.setup(opts)

    local select = require("CopilotChat.select")

    vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
      chat.ask(args.args, { selection = select.visual })
    end, { nargs = "*", range = true })

    -- Inline chat with Copilot
    vim.api.nvim_create_user_command("CopilotChatInline", function(args)
      chat.ask(args.args, {
        selection = select.visual,
        window = {
          layout = "float",
          relative = "cursor",
          width = 1,
          height = 0.4,
          row = 1,
          border = "rounded",
          title = "CopilotChat",
          zindex = 100,
        },
      })
    end, { nargs = "*", range = true })

    -- Restore CopilotChatBuffer
    vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
      chat.ask(args.args, { selection = select.buffer })
    end, { nargs = "*", range = true })

    -- Custom buffer for CopilotChat
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true

        -- Get current filetype and set it to markdown if the current filetype is copilot-chat
        local ft = vim.bo.filetype
        if ft == "copilot-chat" then
          vim.bo.filetype = "markdown"
        end
      end,
    })
  end,
  event = "VeryLazy",
  keys = {
    -- Show prompts actions with telescope
    {
      mode = "n",
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt({
          context = { "buffers" },
        })
      end,
      desc = "CopilotChat - Prompt actions",
    },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      mode = "x",
      desc = "CopilotChat - Prompt actions",
    },
    -- Code related commands
    { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
    { "<leader>aT", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
    { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
    { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
    { "<leader>arv", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
    { mode = "n", "<leader>af", ":CopilotChatFix<CR>", desc = "CopilotChat - Fix" },
    { mode = "n", "<leader>ao", ":CopilotChatOptimize<CR>", desc = "CopilotChat - Optimize" },
    -- Fix the issue with diagnostic
    { "<leader>aF", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
    -- Clear buffer and chat history
    { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
    -- Toggle Copilot Chat Vsplit
    { "<leader>cT", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
    -- Copilot Chat Models
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
    -- Copilot Chat Agents
    { "<leader>aa", "<cmd>CopilotChatAgents<cr>", desc = "CopilotChat - Select Agents" },
    -- Chat with Copilot in visual mode
    {
      "<leader>av",
      ":CopilotChatVisual",
      mode = "x",
      desc = "CopilotChat - Open in vertical split",
    },
    {
      "<leader>aI",
      ":CopilotChatInline",
      mode = "x",
      desc = "CopilotChat - Inline chat",
    },
    -- Custom input for CopilotChat
    {
      "<leader>ai",
      function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          vim.cmd("CopilotChat " .. input)
        end
      end,
      desc = "CopilotChat - Ask input",
    },

    -- Generate commit message based on the git diff
    {
      mode = {
        "n",
        "i",
      },
      "<leader>am",
      "<cmd>CopilotChatCommit<cr>",
      desc = "CopilotChat - Generate commit message for all changes",
    },
    {
      "<leader>aM",
      function()
        local chat = require("CopilotChat")
        local response = chat.ask("", prompts.Commit)
        if response then
          vim.api.nvim_put(vim.split(response, "\n"), "l", true, true)
        end
      end,
      desc = "CopilotChat - Generate commit message for all changes",
    },

    {
      mode = "n",
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
    },
    {
      mode = "n",
      "<leader>ac",
      ": CopilotChat<CR>",
      desc = "Copilot Chat",
    },
  },
}
