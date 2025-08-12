vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pr", vim.cmd.Ex)

-- move highlighted lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- append line below without moving cursor
vim.keymap.set("n", "J", "mzJ`z")

-- no cursor movement with C-d and C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- search terms to stay in the middle of screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep last copied as most recent register
-- instead of deleted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy to clipboard, goat stuff
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- global replace under your cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Remap Ctrl + h to Ctrl + w + h
vim.keymap.set('n', '<C-h>', '<C-w>h', {})
vim.keymap.set('n', '<C-j>', '<C-w>j', {})
vim.keymap.set('n', '<C-k>', '<C-w>k', {})
vim.keymap.set('n', '<C-l>', '<C-w>l', {})

-- Remap 'kj' 'jk' in insert mode to '<Esc>'
vim.keymap.set('i', 'jk', '<Esc>', {})
vim.keymap.set('i', 'kj', '<Esc>', {})

-- ignore case when searching
vim.o.ignorecase = true

-- Configure matchpairs to highlight '<' and '>' pairs
vim.o.matchpairs = vim.o.matchpairs .. ",<:>"

-- Highlight matching parenthesis with specific colors
vim.cmd('highlight MatchParen ctermbg=black ctermfg=white')

-- make control e and control y faster
vim.keymap.set('n', '<C-e>', '5<C-e>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-y>', '5<C-y>', { noremap = true, silent = true })
