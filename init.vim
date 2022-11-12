call plug#begin()
    Plug 'morhetz/gruvbox'
    Plug 'folke/tokyonight.nvim'
    Plug 'mcchrish/zenbones.nvim'
    Plug 'rktjmp/lush.nvim'

    Plug 'jiangmiao/auto-pairs'
    Plug 'neovim/nvim-lspconfig'

    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/vim-vsnip'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'Pocco81/auto-save.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'nvim-lualine/lualine.nvim'

    Plug 'simrat39/rust-tools.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'lervag/vimtex'
 
    Plug 'j-hui/fidget.nvim'
    Plug 'romgrk/barbar.nvim'
    Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'

    Plug 'mhinz/vim-startify'
    " Pra add dps: Surround, Commentary, Symbols-outline

    Plug 'MunifTanjim/nui.nvim'
    Plug 'folke/noice.nvim'
    Plug 'rcarriga/nvim-notify'
    Plug 'kyazdani42/nvim-tree.lua'

    Plug 'petertriho/nvim-scrollbar'

    " Removidos
    " Plug 'sidebar-nvim/sidebar.nvim'

call plug#end()

set tabstop=4
set shiftwidth=4
set expandtab
set guifont=CaskaydiaCove\ NF:h12

set number
set relativenumber
set title
set signcolumn=yes:1
set nowrap
set colorcolumn=80,81
set scrolloff=10
set mouse=a
set cursorline

" Theme stuff
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

set background=dark
colorscheme tokyonight-moon
"highlight SignColumn guibg=#282828
"highlight ColorColumn guibg=#282828
"highlight DiagnosticSignError guibg=#282828 guifg=#f0edec
"highlight DiagnosticSignWarn guibg=#282828 guifg=#d6d3d2
"highlight DiagnosticSignHint guibg=#282828 guifg=#bdbab9
"highlight DiagnosticSignInfo guibg=#282828 guifg=#bdbab9
"highlight FoldColumn guibg=#282828 guifg=#bdbab9
"highlight Folded guibg=None guifg=#7a7a7a


" let g:gruvbox_contrast_light = "soft"
" let g:gruvbox_contrast_dark = "hard"
" set background=light
" colorscheme gruvbox
" hi ColorColumn guibg=#f9f5d7
" highlight SignColumn guibg=#f9f5d7

" Another colorscheme - Tokyo night night
" Spaceduck / ayu

" Neovide specific stuff
if exists("g:neovide")
    let g:neovide_cursor_vfx_mode = "railgun"
    let g:neovide_cursor_vfx_particle_density = 21.0
    let g:neovide_transparency=0.98
    let g:neovide_floating_blur_amount_x=2
    let g:neovide_floating_blur_amount_x=1
endif
 
" Some IDE features
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=8
set foldcolumn=1
set foldtext=getline(v:foldstart).'\ 🐢🐢\ ====>'
set fillchars=fold:\ 

nnoremap <silent> z0 <Cmd>set foldlevel=0<CR>
nnoremap <silent> z1 <Cmd>set foldlevel=1<CR>
nnoremap <silent> z2 <Cmd>set foldlevel=2<CR>
nnoremap <silent> z3 <Cmd>set foldlevel=3<CR>
nnoremap <silent> z4 <Cmd>set foldlevel=4<CR>
nnoremap <silent> z5 <Cmd>set foldlevel=5<CR>
nnoremap <silent> z6 <Cmd>set foldlevel=6<CR>
nnoremap <silent> z7 <Cmd>set foldlevel=7<CR>
nnoremap <silent> z8 <Cmd>set foldlevel=8<CR>

sign define DiagnosticSignError text=💀 texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn text=🌊 texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo text=👾 texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint text=🌌 texthl=DiagnosticSignHint linehl= numhl=

lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = " ",
            other_hints_prefix = "  ",
            max_len_align = true,
            max_len_align_padding = 1,
        },
    },
    server = {
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
require('lsp_lines').setup()

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      virtual_lines = { only_current_line = true }
    }
)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    -- { name = 'buffer' },
  },
})
EOF

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"rust", "markdown", "markdown_inline", "python",
                        "html", "javascript", "latex", "lua", "vim", "regex",
                        "bash", "markdown", "markdown_inline"},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        }
    }
EOF

lua require("auto-save").setup({execution_message = {message = ""}})

lua require("my_lualine")

" indent markers
lua <<EOF
vim.opt.list = true

require("indent_blankline").setup {
    show_current_context_start = true,
}
EOF

" Spell checking
setlocal spelllang=en,pt_br
set spellsuggest=best,5
" set spell " Ativar se quiser automático

" File type specific
syntax enable
filetype on
filetype plugin on
filetype indent on

lua require"fidget".setup{}

" Mappings for the barbar
nnoremap <silent> <A-l> <Cmd>BufferNext<CR>
nnoremap <silent> <A-k> <Cmd>BufferNext<CR>
nnoremap <silent> <A-h> <Cmd>BufferPrevious<CR>
nnoremap <silent> <A-j> <Cmd>BufferPrevious<CR>
nnoremap <silent> <A-c> <Cmd>BufferClose<CR>
nnoremap <silent> <C-p> <Cmd>BufferPick<CR>

let g:startify_fortune_use_unicode = 1

lua require("nvim-tree").setup({view={width=20}})
nnoremap <silent> gf :NvimTreeToggle <CR>

lua require("noice_setup")

lua require("scrollbar").setup()

