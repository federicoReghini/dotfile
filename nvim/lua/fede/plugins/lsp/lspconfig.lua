return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    -- import mason_lspconfig plugin
    local mason_lspconfig = require("mason-lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    -- Create an autocommand group for LSP configuration
    local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})

    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

        opts.desc = "Focus floating window"
        keymap.set("n", "<leader>wf", function()
          local windows = vim.api.nvim_list_wins()
          for _, win in ipairs(windows) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then -- This is a floating window
              vim.api.nvim_set_current_win(win)
              break
            end
          end
        end, opts)
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Configure language servers
    -- Using vim.lsp.config for Neovim 0.11+
    vim.lsp.config("rust_analyzer", {
      capabilities = capabilities,
      filetypes = { "rust" },
      on_attach = function(client, _)
        -- enable inlay hints
        client.server_capabilities.inlayHintProvider = { chainingHints = true, typeHints = true }
        -- enable on save formatting (using newer format method)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = 0,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
      cmd = {
        "rustup",
        "run",
        "stable",
        "rust-analyzer",
      },
    })

    vim.lsp.config("graphql", {
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    vim.lsp.config("emmet_ls", {
      capabilities = capabilities,
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
    })
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    vim.lsp.config("sqlls", {
      capabilities = capabilities,
      filetypes = { "sql", "mysql", "plsql", "postgresql", "sqlite" },
      settings = {
        sqlLanguageServer = {
          connections = {
            -- Example connection configurations
            -- {
            --   name = "local_postgres",
            --   adapter = "postgresql",
            --   host = "localhost",
            --   port = 5432,
            --   user = "postgres",
            --   database = "mydb"
            -- },
            -- {
          },
          lint = {
            rules = {
              ["align-column-to-the-first"] = "error",
              ["column-new-line"] = "error",
              ["linebreak-after-clause-keyword"] = "error",
              ["reserved-word-case"] = "error",
              ["space-surrounding-operators"] = "error",
              ["where-clause-new-line"] = "error",
              ["align-where-clause-to-the-first"] = "error",
            },
          },
          format = {
            language = "postgresql", -- Specify PostgreSQL dialect
            indent = "  ",
            reservedWordCase = "upper", -- Match your style
            linesBetweenQueries = 2,
          },
          completion = {
            showColumns = true,
            showTables = true,
            showViews = true,
            showFunctions = true,
            showProcedures = true,
          },
        },
      },
      on_attach = function(_, bufnr)
        -- Custom keymaps for SQL files
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "<leader>sf", vim.lsp.buf.format, opts)
        vim.keymap.set("n", "<leader>sr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
      end,
    })

    local installed_servers = mason_lspconfig.get_installed_servers()
    -- Configure diagnostic signs properly (using new API)
    -- Configure diagnostic symbols and display
    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
        numhl = {},
        texthl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "if_many",
      },
    })
    -- Configure each installed server that doesn't have special configuration
    for _, server_name in ipairs(installed_servers) do
      -- Skip servers already configured above
      if
        server_name ~= "rust_analyzer"
        and server_name ~= "svelte"
        and server_name ~= "graphql"
        and server_name ~= "emmet_ls"
        and server_name ~= "lua_ls"
        and server_name ~= "sqlls"
      then
        vim.lsp.config(server_name, {
          capabilities = capabilities,
        })
      end
    end
  end,
}
