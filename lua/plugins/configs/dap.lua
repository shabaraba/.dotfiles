local M = {}

M.setup = function()
    local dap_install = require("dap-install")

    dap_install.setup({
        -- installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
        installation_path = os.getenv('HOME')..'/dotfiles/debugger/',
    })
    dap_install.config('php', {})
    dap_install.config('chrome', {})

end

M.config = function()
    require('dap')
    require('dapui').setup()

    local dap, dapui = require'dap', require'dapui'
    local map = require "core.utils".map

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
      },
      sidebar = {
        -- You can change the order of elements in the sidebar
        elements = {
          -- Provide as ID strings or tables with "id" and "size" keys
          {
            id = "scopes",
            size = 0.75, -- Can be float or integer > 1
          },
          { id = "breakpoints", size = 0.25 },
          -- { id = "stacks", size = 0.25 },
          -- { id = "watches", size = 00.25 },
        },
        size = 40,
        position = "left", -- Can be "left", "right", "top", "bottom"
      },
      tray = {
        elements = { "repl" },
        size = 10,
        position = "bottom", -- Can be "left", "right", "top", "bottom"
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME')..'/dotfiles/debugger/vscode-php-debug/out/phpDebug.js' }
    }

    dap.configurations.php = {
        {
            type = 'php',
            request = 'launch',
            name = 'Listen for Xdebug',
            port = 9000,
            stopOnEntry = false,
            pathMappings = { ["/var/www/html"] = "${workspaceFolder}"},
            xdebugSettings = {
                max_children = 516,
                max_data = 40960,
                max_depth = 5
            },
        },
        {
            type = 'php',
            request = 'launch',
            name = 'Launch currently open script',
            port = 9000,
            program = "${file}",
            cwd = "${fileDirname}",
            stopOnEntry = true,
        }

    }


    vim.fn.sign_define('DapBreakpoint', {text='●', texthl='', linehl='', numhl=''})
    vim.fn.sign_define('DapStopped', {text='▶', texthl='', linehl='', numhl=''})

    map('n', '<leader>dl', "<cmd>lua require'dap'.continue()<CR>")
    map('n', '<leader>do', "<cmd>lua require'dap'.step_over()<CR>")
    map('n', '<leader>di', "<cmd>lua require'dap'.step_into()<CR>")
    map('n', '<leader>db', "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
    map('n', '<leader>ds', "<cmd>lua require'dapui'.toggle()<CR>")
    map('n', '<leader>dq', "<cmd>lua require'dap'.close()<CR><cmd>lua require'dapui'.close()<CR>")
end

return M
