-------------------------------------------------------------------------------
-- packer.nvim
-------------------------------------------------------------------------------
vim.cmd.packadd "packer.nvim"
require("packer").startup({
    function()
        -- Packer
        use "wbthomason/packer.nvim"

        -- LSP
        use "neovim/nvim-lspconfig"
        use "williamboman/mason.nvim"
        use "williamboman/mason-lspconfig.nvim"

        -- LSP Completion
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "hrsh7th/cmp-cmdline"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/vim-vsnip"
        use { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" }
        use "onsails/lspkind.nvim"

        -- Yank between vims
        use "vim-scripts/yanktmp.vim"

        -- File Explorer
        use "nvim-tree/nvim-tree.lua"
        use "nvim-tree/nvim-web-devicons"

        -- Buffer Tab Plugin
        use "akinsho/bufferline.nvim"

        -- Word Highlight
        -- use "RRethy/vim-illuminate"

        -- Fuzzy Finder
        use "nvim-telescope/telescope.nvim"

        -- Git
        use "kdheepak/lazygit.nvim"

        -- Toggle Terminal
        use "akinsho/toggleterm.nvim"

        -- Show Mark
        use "chentoast/marks.nvim"

        -- Slime
        use "jpalardy/vim-slime"

        -- QuickScope
        use "unblevable/quick-scope"
    end,
    config = {
        clone_timeout = 300
    }
})

-------------------------------------------------------------------------------
-- mason and mason-lspconfig
-------------------------------------------------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",
        "terraformls",
    },
})

require("mason-lspconfig").setup_handlers({
  function()
    require("lspconfig").terraformls.setup({
      on_attach = function()
          client.server_capabilities.document_formatting = false
          client.server_capabilities.document_range_formatting = false
      end,
      root_dir = function(dirpath)
        return require("lspconfig").util.root_pattern(".terraform", ".git")(dirpath) or require("lspconfig").util.path.dirname(dirpath)
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      filetypes = {
        "terraform",
        "tf",
      }
    })
  end,
})

vim.cmd("autocmd BufNewFile,BufRead *.tf set filetype=terraform")

-------------------------------------------------------------------------------
-- nvim-lspconfig
-------------------------------------------------------------------------------
require("lspconfig").pyright.setup({})


-------------------------------------------------------------------------------
-- null-ls
-------------------------------------------------------------------------------
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,   -- python formatter
        null_ls.builtins.formatting.isort,   -- python import sort
        null_ls.builtins.diagnostics.flake8, -- python linter
    },
})

-------------------------------------------------------------------------------
-- toggleterm
-------------------------------------------------------------------------------
require("toggleterm").setup({ })

vim.keymap.set('n', '<C-k><C-r>', ":ToggleTerm<CR>", {silent = true})
--vim.keymap.set('n', '<C-t><C-t>', ":ToggleTerm<CR><C-w><CR>make<CR>", {silent = true})
vim.keymap.set('n', '<C-k><C-l>', ":w<CR>:ToggleTerm<CR><C-w><CR>make<CR>", {silent = true})
vim.keymap.set('n', '<C-k><C-t>', ":w<CR>:ToggleTerm<CR><C-w><CR>make test<CR>", {silent = true})

-------------------------------------------------------------------------------
-- nvim-tree
-------------------------------------------------------------------------------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    side = "left"
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.keymap.set('n', '<C-k><C-e>', ":NvimTreeOpen<CR>", {})

-------------------------------------------------------------------------------
-- bufferline
-------------------------------------------------------------------------------
vim.opt.termguicolors = true
require("bufferline").setup{}

-------------------------------------------------------------------------------
-- nvim-cmp.nvim
-------------------------------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
    ['<C-f>']     = cmp.mapping.scroll_docs(4),
    ['<C-l>']     = cmp.mapping.complete(),
    ['<C-e>']     = cmp.mapping.abort(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<C-w>']     = cmp.mapping(function(fallback)
      if vim.fn["vsnip#expandable"]() then
        vim.fn["vsnip#expand"]()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, 
  {
    { name = 'cmdline' }
  }
  )
})

--
-- lspkind.nvim
--
local lspkind = require("lspkind")
cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
                return vim_item
            end,
        }),
    },
})

-------------------------------------------------------------------------------
-- yanktmp
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('v', 'sy',":call YanktmpYank()<CR>",    {silent = true})
vim.api.nvim_set_keymap('n', 'sp',":call YanktmpPaste_p()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', 'sP',":call YanktmpPaste_P()<CR>", {silent = true})


-------------------------------------------------------------------------------
-- lazygit
-------------------------------------------------------------------------------
vim.api.nvim_set_keymap('n', 'gt',":LazyGit<CR>", {silent = true})


-------------------------------------------------------------------------------
-- nvim-telescope
-------------------------------------------------------------------------------
vim.keymap.set('n', '<C-k><C-f>', ":Telescope find_files<CR>", {})
vim.keymap.set('n', '<C-k><C-g>', ":Telescope live_grep<CR>", {})


-------------------------------------------------------------------------------
-- Marks
-------------------------------------------------------------------------------
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world"
  },
  mappings = {}
}

-- For Slime
vim.cmd([[
let g:slime_target = "tmux"
xmap <c-o><c-o> <Plug>SlimeRegionSend
nmap <c-o><c-o> <Plug>SlimeParagraphSend
nmap <c-c>v     <Plug>SlimeConfig
]])

