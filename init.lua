vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop     = 4     -- length of an actual \t character
vim.opt.softtabstop = 0     -- length to use when editing text (TAB, BS keys); (0 for ‘tabstop’, -1 for ‘shiftwidth’)
vim.opt.expandtab   = true  -- if set, only insert spaces; otherwise insert \t and complete with spaces
vim.opt.smarttab    = false -- prevents BS from erasing whole TAB length of spaces
vim.opt.shiftwidth  = 0     -- length to use when shifting text (<<, >> and ==); (0 for ‘tabstop’)
vim.opt.autoindent  = true  -- reproduce the indentation of the previous line
vim.opt.smartindent = true  -- try to be smart (increase the indenting level after ‘{’, decrease it after ‘}’, and so on)

-- Change indentation depending on filetype
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        local filetype = vim.bo.filetype
        if filetype == "c" or filetype == "cpp" then
            vim.o.tabstop = 8
            vim.opt.smartindent = false
            vim.opt.cindent = true -- a stricter alternative to smartindent, works better for C
        elseif filetype == "yaml" then
            vim.o.tabstop = 4
            vim.opt.shiftwidth  = 0
            vim.opt.softtabstop = 0
        elseif filetype == "css" then
            vim.o.tabstop = 2
            vim.opt.shiftwidth  = 0
        end
    end,
})

vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Completion setup, stolen cuz im dumb
-- https://neovim.io/doc/user/lsp/#lsp-attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp'),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
            vim.keymap.set("i", "<C-e>", vim.lsp.buf.implementation, { desc = "trigger autocompletion" })
        end
        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
        vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
    end
})

vim.cmd(":set nowrap")

vim.o.timeoutlen  = 250 -- Normanl timeout
vim.o.ttimeoutlen = 150 -- Terminal timeout

local map = vim.keymap.set

-- Escape key replace
map("i", "jj", "<ESC>", { desc = "Quit insert mode" }, { silent = true })
map("i", "jk", "<ESC>", { desc = "Quit insert mode" }, { silent = true })
map("t", "jj", "<C-\\><C-N>", { desc = "Quit terminal mode" })
map("t", "jk", "<C-\\><C-N>", { desc = "Quit terminal mode" })

-- File operations
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit command" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write command" })
map("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Write and quit command" })

-- Highlight reset
map("n", "<leader>c", "<cmd>noh<CR>", { desc = "Reset last highlight" })

-- Terminal window
map("n", "<leader>t", "<cmd>vert term<CR> <C-W>R i", { desc = "Open and move terminal window to the other side" })

-- Window control
map("n", "<leader>ww", "<C-W>W", { desc = "Change window focus"    })
map("n", "<leader>wr", "<C-W>R", { desc = "Change window position" })
map("n", "<leader>h",  "<C-W>h", { desc = "Switch to left window"  })
map("n", "<leader>j",  "<C-W>j", { desc = "Switch to lower window" })
map("n", "<leader>k",  "<C-W>k", { desc = "Switch to upper window" })
map("n", "<leader>l",  "<C-W>l", { desc = "Switch to right window" })

-- Line jumps
map("n", "n", "nzz", { desc = "Jump to next match and center the screen" })
map("n", "N", "Nzz", { desc = "Jump to previous match and center the screen" })

-- LSP
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code rename" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
map('n', '<leader>do', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
map('n', '<leader>d[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
map('n', '<leader>d]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
map('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })

-- Easier copying
map('v', '<leader>y', '"+y')

-- Set universal .git root marker
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            semanticTokens = {
                multilineTokenSupport = true,
            }
        }
    },
    root_markers = { '.git' },
})

vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("systemd_lsp")
vim.lsp.enable("lua_ls")

-- Basic syntax highlighting
vim.cmd.syntax("enable")

-- Default theme
vim.cmd.colorscheme("kanagawa-dragon") -- Favorites: tokyonight-night, catppuccin-mocha, kanagawa (dragon)
