-- Set number
vim.opt.number       =  true

-- No backups
vim.opt.backup       =  false

-- Expand a tab
vim.opt.expandtab    =  true

-- Tab width
vim.opt.tabstop      =  4

-- Tab width after indent
vim.opt.shiftwidth   =  4

-- Enable autoindent
vim.opt.autoindent   =  true

-- Enable change when buffer has been edited
vim.opt.hidden       =  true

-- Ignore case while search
vim.opt.ignorecase   =  true

-- Disable ignorecase if the search pattern has uppar case characters
vim.opt.smartcase    =  true

-- Enable incremental search
vim.opt.incsearch    =  true

-- Auto read when a file has been detected to have been changed outsize of Vim
vim.opt.autoread     =  true

-- Modeline settings
vim.opt.modeline     =  true
vim.opt.modelines    =  5

-- Smart settings
vim.opt.smarttab     =  true
vim.opt.smartindent  =  true

-- Ambiguous width
vim.opt.ambiwidth    =  double

-- Execute make command
-- vim.keymap.set('n', '<C-k><C-l>', ":w<CR>:make<CR>", {})

-- Insert date
vim.keymap.set('n', '<C-k><C-o>', 'O<Esc>:.! date +\\%Y-\\%m-\\%d<CR>', {})

-- Move between buffers
vim.keymap.set('n', '<C-p>', ":<ESC>:bp<CR>", {})
vim.keymap.set('n', '<C-n>', ":<ESC>:bn<CR>", {})

-- Toggle paste mode
vim.keymap.set('n', '<C-k><C-i>', ":set paste<CR>", {})
vim.keymap.set('n', '<C-k><C-u>', ":set nopaste<CR>", {})

-- Visualize tab and trail
vim.opt.list = true
vim.opt.listchars = { tab = '>-', trail = '·' }

-- Show cursorline
-- vim.opt.cursorline = true

-- Don't expand tab with Makefile
vim.cmd([[autocmd FileType make setlocal noexpandtab]])

-- copy yanked text to clipboard
vim.opt.clipboard:append("unnamed")

-- Show ZenkakuSpace
--vim.cmd([[highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white]])
vim.cmd([[match ZenkakuSpace /　/]])

-- StatusLine settings
vim.opt.laststatus = 2
vim.cmd([[
    set statusline=%<%f\ %m%r%h%w
    set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}
    set statusline+=%=%l/%L,%c%V%8P
    hi StatusLine term=standout ctermfg=white ctermbg=black
]])

-- Keep cursor position
vim.cmd([[
    " Keep cursor position
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
]])
