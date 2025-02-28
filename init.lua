--================================
--        Lionvim Config
--
--
-- Author: Zane B.
-- Last Modified: 2023-04-27
-- Dependencies:
--   bat
--   deno (for markdown previews)
--   eja,
--   fd,
--   fzf > 0.30.0,
--   howdoi
--   ripgrep
--================================

----------------------------------
--           Aliases
----------------------------------
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local hi = vim.api.nvim_set_hl
local notify = notify
local opt = vim.opt

local function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(
		mode,
		shortcut,
		command,
		{ noremap = true, silent = true }
	)
end

local function bufnr_map(bufnr, mode, shortcut, command)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		mode,
		shortcut,
		command,
		{ noremap = true, silent = true }
	)
end

local function nmap(shortcut, command)
	map('n', shortcut, command)
end

local function nmap_buf(bufnr, shortcut, command)
	bufnr_map(bufnr, 'n', shortcut, command)
end

local function imap(shortcut, command)
	map('i', shortcut, command)
end

local function vmap(shortcut, command)
	map('v', shortcut, command)
end

----------------------------------
--           Options
----------------------------------
opt.clipboard = 'unnamed' -- use system clipboard
opt.cmdheight = 0
opt.cursorline = true     -- highlight current line
opt.fillchars = {         -- thicker borders between windows
	horiz = '━',
	horizup = '┻',
	horizdown = '┳',
	vert = '┃',
	vertleft = '┫',
	vertright = '┣',
	verthoriz = '╋',
}
opt.ignorecase = true -- ignore case when searching
opt.laststatus = 3 -- one statusline for all windows
opt.linebreak = true -- break lines
opt.mouse = 'nicr' -- use mouse for scrolling and clicking
opt.number = true -- line numbers
opt.scrolloff = 15 -- keep 15 lines above/below cursor line
opt.shiftwidth = 2 -- make indents correspond to one tab
opt.showbreak = '↪ ' -- show ↪ on wrapped lines
opt.showmode = false -- don't show the mode in bottom-left
opt.smartcase = true -- override ignore case if uppercase letters in pattern
opt.smartindent = true -- indent after brackets
opt.splitbelow = true -- split splits below
opt.splitright = true -- vertical split splits right
opt.tabstop = 2 -- make tabs 2-spaces wide
opt.termguicolors = true -- enable 24-bit RGB color
opt.timeoutlen = 300 -- quicker inputs
opt.undofile = true -- persistent undo
opt.updatetime = 300 -- faster update time

-- Lionvim-specific options
g.ENABLE_FORMAT_ON_SAVE = true       -- whether or not to autoformat on save
g.SHOW_NOTIFICATION_ON_FORMAT = true -- whether or not to show notifications on format
g.show_neotree_on_startup = false    -- whether or not to show neo-tree on startup
g.auto_open_markdown_previews = true -- whether or not to automatically open markdown previews in deno

-- Neovide-specific options
if g.neovide then
	g.neovide_transparency = 0.9
	g.neovide_floating_blur_amount_x = 2.0
	g.neovide_floating_blur_amount_y = 2.0
	g.neovide_refresh_rate = 120
	g.neovide_confirm_quit = true
	g.neovide_remember_window_size = true
	g.neovide_cursor_antialiasing = true
	-- Use Cmd+C/V for copy paste
	nmap('<D-v>', '"+p')
	map('t', '<D-v>', '"+p')
	imap('<D-v>', '<C-o>"+p')
	nmap('<D-c>', '"+y')
	map('t', '<D-c>', '"+y')
	imap('<D-c>', '<C-o>"+y')
end

-- git-blame.nvim options
g.gitblame_enabled = 0

augroup('options', { clear = true })

-- turn off linenumber for terminals and autoenter insert mode
autocmd('TermOpen', {
	group = 'options',
	pattern = '*',
	callback = function()
		opt.number = false
		opt.relativenumber = false
		vim.api.nvim_command('startinsert')
	end,
})

----------------------------------
--           Mappings
----------------------------------
-- Remap leader to ,
g.mapleader = ','

-- Easy command input
nmap(':', '<cmd>FineCmdline<cr>')
nmap(';', '<cmd>FineCmdline<cr>')

-- Quick Save/Quit
nmap('<C-s>', '<cmd>w<cr>')
nmap('wf', '<cmd>w<cr>')
nmap('qa', '<cmd>qa<cr>')
nmap('qf', '<cmd>qa!<cr>')
nmap('qs', '<cmd>wqa<cr>')
nmap('qw', '<cmd>wq<cr>')
-- Close buffer but preserve window layout
nmap('qq', '<cmd>Bdelete<cr>')

-- Move up and down by display rather than line number
nmap('j', 'gj')
nmap('k', 'gk')

-- Move lines with Shift + Up/Down
nmap('<S-Down>', '<cmd>m+<cr>')
nmap('<S-Up>', '<cmd>m-2<cr>')

-- Keep cursor in middle when using Ctrl+u/d and searching
nmap('<C-d>', '<C-d>zz')
nmap('<C-u>', '<C-u>zz')
nmap('n', 'nzzzv')
nmap('N', 'Nzzzv')

-- Keep cursor position when joining lines
nmap('J', 'mzJ`z')

-- Easy window navigation
nmap('<C-h>', [[<c-\><c-n><c-w>h]])
nmap('<C-j>', [[<c-\><c-n><c-w>j]])
nmap('<C-k>', [[<c-\><c-n><c-w>k]])
nmap('<C-l>', [[<c-\><c-n><c-w>l]])

-- Close window
nmap('<C-q>', '<cmd>close<cr>')

-- New file
nmap('<C-n>', '<cmd>enew<cr>')

-- Replace
nmap('rl', ':s/')

-- Toggle search highlight
nmap('<leader><space>', '<cmd>set hlsearch!<cr>')

-- Open splits
nmap('<C-v>', '<cmd>vsp<cr>')
nmap('<C-h>', '<cmd>sp<cr>')

-- Trim trailing whitespace
nmap('rtw', '<cmd>%s/\\s\\+$//<cr><cmd>nohlsearch<cr>')
-- Trim ^M windows carriage characters
nmap('rtm', '<cmd>%s/^M//g<cr>')

-- Don't unselect after shifting in visual mode
vmap('<', '<gv')
vmap('>', '>gv')

-- Insert blank line with enter
nmap('<cr>', 'o<Esc>')

-- Navigate diagnostics
nmap('<F1>', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
nmap('<F2>', '<cmd>lua vim.diagnostic.goto_next()<cr>')

-- Disable mouse drag entering visual mode
nmap('<LeftDrag>', '<LeftMouse>')

-- Open this config
nmap('<leader>s', '<cmd>e $MYVIMRC | :cd %:p:h <cr>')

-- Terminal mappings
map('t', '<C-q>', '<cmd>close<cr>')
map('t', '<Esc>', '<cmd>close<cr>')
map('t', '<C-h>', [[<c-\><c-n><c-w>h]])
map('t', '<C-j>', [[<c-\><c-n><c-w>j]])
map('t', '<C-k>', [[<c-\><c-n><c-w>k]])
map('t', '<C-l>', [[<c-\><c-n><c-w>l]])

-- aerial mappings
nmap('<space>o', '<cmd>AerialToggle!<cr>')

-- bufferline mappings
nmap('<Left>', '<cmd>BufferLineCyclePrev<cr>')
nmap('<Right>', '<cmd>BufferLineCycleNext<cr>')
nmap('<S-Left>', '<cmd>BufferLineMovePrev<cr>')
nmap('<S-Right>', '<cmd>BufferLineMoveNext<cr>')
nmap('ww', '<cmd>BufferLinePick<cr>')

-- ChatGPT mappings
nmap('<leader>c', '<cmd>ChatGPT<cr>')
vmap('<leader>r', '<cmd>ChatGPTEditWithInstructions<cr>')

-- dap mappings
nmap('<c-b>', '<cmd>lua require("dapui").toggle()<cr>')
vmap('be', '<cmd> lua require("dapui").eval()<cr>)')
nmap('bb', '<cmd>DapToggleBreakpoint<cr>')
nmap('bl', '<cmd>Telescope dap list_breakpoints<cr>')
nmap('bv', '<cmd>Telescope dap variables<cr>')
nmap('bf', '<cmd>Telescope dap frames<cr>')
nmap('bc', '<cmd>DapContinue<cr>')
nmap('bt', '<cmd>DapTerminate<cr>')
nmap('bo', '<cmd>DapStepOver<cr>')
nmap('bi', '<cmd>DapStepInto<cr>')
nmap('bO', '<cmd>DapStepOut<cr>')

-- fm-nvim mappings
map('t', '<A-r>', '<cmd>close<cr>')
nmap('fz', '<cmd>Fzf<cr>')

-- formatter mappings
nmap('rf', '<cmd>lua Format()<cr>')

-- git-blame.nvim mappings
nmap('<leader>b', '<cmd>GitBlameToggle<cr>')

-- leap.nvim mappings
nmap('ws', '<cmd>lua SearchRef()<cr>')

-- muren.nvim mappings
nmap('rs', '<cmd>MurenToggle<cr>')

-- neo-tree mappings
nmap('<C-f>', '<cmd>Neotree toggle<cr>')

-- oil mappings
nmap('<C-c>', '<cmd>Oil --float .<cr>')

-- searchbox.nvim mappings
nmap('/', '<cmd>SearchBoxMatchAll<cr>')
nmap('rg', '<cmd>SearchBoxReplace confirm=menu<cr>')
nmap('rw', ':SearchBoxReplace confirm=menu -- <C-r>=expand("<cword>")<cr><cr>')

-- SnipRun mappings
nmap('er', '<cmd>SnipRun<cr>')
nmap('el', '<cmd>SnipLive<cr>')
nmap('eq', '<cmd>SnipReset<cr>')
nmap('ec', '<cmd>SnipClose<cr>')
vmap('r', '<Plug>SnipRun')

-- Telekasten mappings
nmap('<leader>n', '<cmd>Telekasten panel<cr>')
nmap('<leader>nn', '<cmd>Telekasten new_templated_note<cr>')
nmap('<leader>nf', '<cmd>Telekasten find_notes<cr>')
nmap('<leader>ns', '<cmd>Telekasten search_notes<cr>')
nmap('<leader>nl', '<cmd>Telekasten insert_link<cr>')
nmap('<leader>ni', '<cmd>Telekasten paste_img_and_link<cr>')
nmap('<leader>nd', '<cmd>Telekasten goto_today<cr>')

-- Telescope mappings
nmap('fg', '<cmd>Telescope live_grep hidden=true<cr>')
nmap('ff', '<cmd>Telescope find_files<cr>')
nmap('<C-o>', '<cmd>Telescope find_files<cr>')
nmap(
	'fb',
	'<cmd>lua require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({ previewer = false, layout_config = { height = 20 }}))<cr>'
)
nmap(
	'fw',
	'<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false, prompt_title = "", layout_config = { height = 40 }}))<cr>'
)
nmap('fm', '<cmd>Telescope marks<cr>')
nmap('fr', '<cmd>Telescope oldfiles prompt_title=Recents<cr>')
nmap('fs', '<cmd>Telescope treesitter prompt_title=Symbols<cr>')
nmap('fu', '<cmd>Telescope undo<cr>')
nmap('fh', '<cmd>Telescope howdoi<cr>')
nmap('cd', '<cmd>Telescope cder<cr>')
nmap('<space>c', '<cmd>Telescope command_center<cr>')
nmap(
	'<leader>l',
	'<cmd>lua require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown({ layout_config = { height = 20 }}))<cr>'
)
nmap('<F4>', '<cmd>Telescope man_pages<cr>')
nmap('<F5>', '<cmd>Telescope help_tags<cr>')
nmap('<F6>', '<cmd>Telescope keymaps<cr>')

-- toggleterm mappings
nmap('<leader>t', '<cmd>ToggleTerm direction=float<cr>')
map('t', '<leader>t', '<cmd>ToggleTerm direction=float<cr>')

nmap('<leader>x', '<cmd>lua ToggleHorizontalTerminal()<cr>')
map('t', '<leader>x', '<cmd>lua ToggleHorizontalTerminal()<cr>')

nmap('<leader>g', '<cmd>lua ToggleLazygit()<cr>')
map('t', '<leader>g', '<cmd>lua ToggleLazygit()<cr>')

nmap('<leader>v', '<cmd>lua ToggleVtop()<cr>')
map('t', '<leader>v', '<cmd>lua ToggleVtop()<cr>')

nmap('<leader>p', '<cmd>lua ToggleIPython()<cr>')
map('t', '<leader>p', '<cmd>lua ToggleIPython()<cr>')

-- treesj mappings
nmap('<leader>j', '<cmd>TSJToggle<cr>')

-- undotree mappings
nmap('<leader>u', '<cmd>UndotreeToggle<cr>')

-- which-key mappings
nmap('?', '<cmd>WhichKey<cr>')

-- workspaces mappings
nmap('wo', '<cmd>Telescope workspaces<cr>')

-----------------------------------
--            Plugins
-----------------------------------
-- Bootstrap package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- Autocompletion
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-path',
	'hrsh7th/nvim-cmp',
	'saadparwaiz1/cmp_luasnip',
	-- Colorschemes
	{ 'catppuccin/nvim',  name = 'catppuccin' },
	'folke/tokyonight.nvim',
	-- LSP
	'neovim/nvim-lspconfig', -- completion, go-to, etc.
	'nvimdev/lspsaga.nvim', -- LSP enhancements
	{
		'williamboman/mason.nvim',
		build = ':MasonUpdate',           -- :MasonUpdate updates registry contents
	},
	'williamboman/mason-lspconfig.nvim', -- lsp support for mason
	'rmagatti/goto-preview',            -- goto preview popup
	-- DAP
	'mfussenegger/nvim-dap',            -- debugger
	'mfussenegger/nvim-dap-python',     -- debugger config for python
	'nvim-neotest/nvim-nio',            -- req for dap
	'jay-babu/mason-nvim-dap.nvim',     -- dap installer
	'nvim-telescope/telescope-dap.nvim',
	'rcarriga/nvim-dap-ui',             -- UI for debugger
	'theHamsta/nvim-dap-virtual-text',
	-- Programming support
	'f-person/git-blame.nvim',                          -- inline git blame
	'L3MON4D3/LuaSnip',                                 -- snippet engine
	'mhartington/formatter.nvim',                       -- formatting
	{ 'michaelb/sniprun', build = 'bash ./install.sh' }, -- execute code inline
	'natecraddock/workspaces.nvim',                     -- workspace support
	'numToStr/Comment.nvim',                            -- smart comments support
	'nvim-treesitter/nvim-treesitter',                  -- additional syntax highlighting
	'nvim-treesitter/nvim-treesitter-textobjects',      -- class and function textobjects
	'rafamadriz/friendly-snippets',                     -- common snippets package
	'skywind3000/asyncrun.vim',                         -- run commands async
	'tpope/vim-fugitive',                               -- git
	'tpope/vim-surround',                               -- easily change surrounding brackets, quotes, etc.
	'tpope/vim-repeat',                                 -- support plugins for dot repeat
	'windwp/nvim-autopairs',                            -- auto pair ( {, etc.
	'windwp/nvim-ts-autotag',                           -- autoclose html, etc. tags
	'wintermute-cell/gitignore.nvim',                   -- gitignore generation
	-- Telescope
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	'nvim-telescope/telescope-media-files.nvim',                                           -- previewer for media files
	'nvim-telescope/telescope.nvim',                                                       -- aesthetic finder popup
	'nvim-telescope/telescope-symbols.nvim',                                               -- emoji + ascii symbols
	'stevearc/dressing.nvim',                                                              -- use telescope for more things
	-- UI
	'akinsho/bufferline.nvim',                                                             -- fancy buffer line
	'akinsho/toggleterm.nvim',                                                             -- better terminals
	'Bekaboo/dropbar.nvim',                                                                -- winbar with file context
	'eandrju/cellular-automaton.nvim',                                                     -- fancy animation
	'folke/which-key.nvim',                                                                -- shortcut popup
	'folke/trouble.nvim',                                                                  -- aesthetic diagnostics page
	'goolord/alpha-nvim',                                                                  -- fancy start page
	'j-hui/fidget.nvim',                                                                   -- LSP progress indicator
	'kosayoda/nvim-lightbulb',                                                             -- show a lightbulb for code actions
	'kyazdani42/nvim-web-devicons',                                                        -- file icons
	'lewis6991/gitsigns.nvim',                                                             -- git integration
	'lukas-reineke/indent-blankline.nvim',                                                 -- identation lines
	'munifTanjim/nui.nvim',                                                                -- UI dependency
	'nvim-lualine/lualine.nvim',                                                           -- status line
	'nvim-lua/plenary.nvim',                                                               -- UI dependency
	'nvim-lua/popup.nvim',                                                                 -- UI dependency
	'nvim-neo-tree/neo-tree.nvim',                                                         -- filetree
	'rcarriga/nvim-notify',                                                                -- fancy notifications
	'RRethy/vim-illuminate',                                                               -- highlight symbol under cursor
	'stevearc/aerial.nvim',                                                                -- function outline
	'VonHeikemen/searchbox.nvim',                                                          -- search popup
	'VonHeikemen/fine-cmdline.nvim',                                                       -- command input popup
	'zane-/command_center.nvim',                                                           -- command palette
	'zane-/symbols-outline.nvim',                                                          -- menu for symbols
	-- Utility
	'AckslD/muren.nvim',                                                                   -- multiple find and replace
	'andrewradev/switch.vim',                                                              -- smart switch between stuff
	'debugloop/telescope-undo.nvim',                                                       -- undotree in telescope
	'ggandor/leap.nvim',                                                                   -- navigation
	'is0n/fm-nvim',                                                                        -- for ranger
	'jackMort/ChatGPT.nvim',                                                               -- chatGPT integration
	'max397574/better-escape.nvim',                                                        -- better insert mode exit
	'mbbill/undotree',                                                                     -- file history tree
	'renerocksai/telekasten.nvim',                                                         -- for taking notes
	'rktjmp/paperplanes.nvim',                                                             -- upload buffer online
	'rmagatti/auto-session',                                                               -- sessions based on cwd
	'stevearc/oil.nvim',                                                                   -- edit directory in a buffer
	{ 'toppair/peek.nvim',                        build = 'deno task --quiet build:fast' }, -- live markdown preview
	'Wansmer/treesj',                                                                      -- join/split blocks of code
	'wellle/targets.vim',                                                                  -- more text objects
	'zane-/bufdelete.nvim',                                                                -- layout-preserving buffer deletion
	'zane-/howdoi.nvim',                                                                   -- howdoi queries with telescope
	'zane-/cder.nvim',                                                                     -- change working directory with telescope
}

require('lazy').setup(plugins)

----------------------------------
--            Colors
----------------------------------
g.catppuccin_flavor = 'mocha' -- latte, frappe, macchiato, mocha
cmd([[ colorscheme catppuccin ]])

local colors = require('catppuccin.palettes').get_palette('mocha')

hi(0, 'StatusLine', { ctermbg = 0, bg = colors.crust })
hi(0, 'Pmenu', { ctermbg = 0, fg = colors.text, bg = colors.mantle })

-- Highlights for DAP
hi(0, 'DapBreakpoint', { ctermbg = 0, fg = colors.red, bg = colors.mantle })
hi(0, 'DapLogPoint', { ctermbg = 0, fg = colors.blue, bg = colors.mantle })
hi(0, 'DapStopped', { ctermbg = 0, fg = colors.green, bg = colors.mantle })
hi(0, 'DapUIVariable', { ctermbg = 0, fg = colors.teal })
hi(0, 'DapUIScope', { ctermbg = 0, fg = colors.blue })
hi(0, 'DapUIType', { ctermbg = 0, fg = colors.lavender })
hi(0, 'DapUIValue', { ctermbg = 0, bg = colors.mantle })
hi(0, 'DapUIModifiedValue', { ctermbg = 0, fg = colors.sapphire })
hi(0, 'DapUIDecoration', { ctermbg = 0, fg = colors.teal })
hi(0, 'DapUIThread', { ctermbg = 0, fg = colors.green })
hi(0, 'DapUIStoppedThread', { ctermbg = 0, fg = colors.blue })
hi(0, 'DapUIFrameName', { ctermbg = 0, bg = colors.mantle })
hi(0, 'DapUISource', { ctermbg = 0, fg = colors.green })
hi(0, 'DapUILineNumber', { ctermbg = 0, fg = colors.teal })
hi(0, 'DapUIFloatBorder', { ctermbg = 0, fg = colors.teal })
hi(0, 'DapUIWatchesEmpty', { ctermbg = 0, fg = colors.blue })
hi(0, 'DapUIWatchesValue', { ctermbg = 0, fg = colors.green })
hi(0, 'DapUIWatchesError', { ctermbg = 0, fg = colors.red })
hi(0, 'DapUIBreakpointsPath', { ctermbg = 0, fg = colors.teal })
hi(0, 'DapUIBreakpointsInfo', { ctermbg = 0, fg = colors.green })
hi(0, 'DapUIBreakpointsCurrentLine', { ctermbg = 0, fg = colors.surface1 })
hi(0, 'DapUIBreakpointsLine', { ctermbg = 0, fg = colors.surface1 })
hi(0, 'DapUIBreakpointsDisabledLine', { ctermbg = 0, fg = colors.red })

-- Highlights for leap
hi(0, 'LeapMatch', { ctermbg = 0, fg = colors.yellow, bg = colors.surface0 })
hi(
	0,
	'LeapLabelPrimary',
	{ ctermbg = 0, fg = colors.red, bg = colors.surface0 }
)
hi(
	0,
	'LeapLabelSecondary',
	{ ctermbg = 0, fg = colors.peach, bg = colors.surface0 }
)

-- Highlights for neo-tree
hi(0, 'NeoTreeNormal', { ctermbg = 0, bg = colors.mantle })
hi(0, 'NeoTreeNormalNC', { ctermbg = 0, bg = colors.mantle })

-- Highlights for Sniprun
hi(
	0,
	'SniprunVirtualTextOk',
	{ ctermbg = 0, fg = colors.blue, bg = colors.mantle }
)
hi(
	0,
	'SniprunVirtualTextErr',
	{ ctermbg = 0, fg = colors.red, bg = colors.mantle }
)
hi(
	0,
	'SniprunFloatingWinOk',
	{ ctermbg = 0, fg = colors.blue, bg = colors.mantle }
)
hi(
	0,
	'SniprunFloatingWinErr',
	{ ctermbg = 0, fg = colors.red, bg = colors.mantle }
)

-- Highlights for Telescope
hi(0, 'TelescopePreviewTitle', { ctermbg = 0, fg = colors.blue })
hi(
	0,
	'TelescopePromptTitle',
	{ ctermbg = 0, fg = colors.text, bg = colors.mantle }
)

-- Highlights for trouble
hi(0, 'TroubleNormal', { ctermbg = 0, bg = colors.mantle })

-- Highlights for symbols-outline
hi(0, 'FocusedSymbol', { ctermbg = 0, bg = colors.mantle })

--================================
--     Global Util Functions
--================================
notify = require('notify')

local lionvim_notify_options = {
	title = '🦁 lionvim',
	timeout = 1000,
}

GetLspClientName = function()
	local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
	local clients = vim.lsp.get_active_clients()

	if next(clients) == nil then
		return nil
	end

	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end

	return nil
end

ToggleFormatOnSave = function()
	if g.ENABLE_FORMAT_ON_SAVE then
		g.ENABLE_FORMAT_ON_SAVE = false
		notify('Format on save disabled', 'info', lionvim_notify_options)
	else
		g.ENABLE_FORMAT_ON_SAVE = true
		notify('Format on save enabled', 'info', lionvim_notify_options)
	end
end

ToggleFormatNotifications = function()
	if g.SHOW_NOTIFICATION_ON_FORMAT then
		g.SHOW_NOTIFICATION_ON_FORMAT = false
		notify('Format notifications disabled', 'info', lionvim_notify_options)
	else
		g.SHOW_NOTIFICATION_ON_FORMAT = true
		notify('Format notifications enabled', 'info', lionvim_notify_options)
	end
end

SearchRef = function()
	local ref = require('illuminate.reference').buf_get_references(
		vim.api.nvim_get_current_buf()
	)
	if not ref or #ref == 0 then
		return false
	end

	local targets = {}
	for _, v in pairs(ref) do
		table.insert(targets, {
			pos = { v[1][1] + 1, v[1][2] + 1 },
		})
	end

	require('leap').leap({
		targets = targets,
		target_windows = { vim.api.nvim_get_current_win() },
	})

	return true
end

--================================
--        Plugin Configs
--================================

----------------------------------
--         alpha config
----------------------------------
require('aerial').setup({
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
		vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
	end,
})

----------------------------------
--         alpha config
----------------------------------
local sections = {}

sections.header = {
	type = 'text',
	val = {
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⢀⣠⠴⢞⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣲⣿⡄⢀⡴⠋⣠⣾⣿⣿⣿⣿⣄⣀⣀⡀⠀⠀⠀⠀⠈⠓⠲⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠎⣼⣿⣿⣿⡟⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣶⣦⣄⡀⠀⠀⠙⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠊⠉⠀⠀⠈⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⡉⠛⢿⣷⣄⠀⠀⠈⢷⡄⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⣀⡀⠤⠐⠒⡁⢴⣤⣤⡀⠀⠀⠀⣠⣼⣿⣿⣏⣀⣀⠀⠉⠛⢿⣿⣿⣿⣿⣿⣷⣄⠙⢿⣷⣄⠀⠀⠹⡄⠀⠀⠀⠀⠀',
		'⢰⣦⣍⣁⠀⠀⠀⠀⠀⠀⢾⡉⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⢸⣿⣿⣿⣿⣿⣿⣷⡄⢻⣿⣆⠀⠀⠑⠀⠀⠀⠀⠀',
		'⠈⠀⠀⠀⠀⠀⠀⠀⠠⠀⠀⠁⠁⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⡿⠋⢀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⢻⣿⡄⠀⠀⠁⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⡻⢿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣎⣿⣷⠀⠀⠀⠀⠀⠀⠀',
		'⢀⠀⠀⠀⠀⠀⠀⠀⢸⠾⠀⢀⣠⣶⠀⣠⣾⣿⣿⣿⣿⣦⡉⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣇⠀⠀⠀⠀⠀⠀',
		'⠀⢹⠁⠰⠉⠉⠒⢄⣸⡷⠿⠛⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀',
		'⠀⠀⢇⡇⠀⠀⠀⠘⠁⣿⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠈⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀',
		'⠀⠀⠀⠁⠀⠀⠀⠀⠀⣿⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣯⠻⢿⣿⣿⣿⣷⣶⡆',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⢀⣿⣿⣿⣷⣶⣶⣾⣿⡿⠟⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⣼⣿⣿⣿⣿⣿⡍⠁⠀⠀⠀⠀',
		'⠀⠀⢀⠞⡄⠀⠀⢠⣿⣣⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⠏⣼⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀',
		'⠀⠀⢸⣀⣇⠠⠔⢫⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢫⣾⣿⣿⣿⡿⢣⣿⣿⡇⠀⠀⠀⠀⠀',
		'⠀⠀⠰⡀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⠟⢁⣾⣿⣿⠁⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠑⡄⢸⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢁⣴⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠈⠚⠉⠉⠁⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⢛⣉⣤⣶⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⠟⡇⠈⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣿⣿⣿⡿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠹⣿⣿⣿⣿⣿⡏⠀⣿⡀⢻⣿⣿⣿⣿⣿⣿⠟⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⠈⠻⣿⣿⣿⡇⠀⠸⣷⡀⢿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣄⠀⠈⠙⠿⣿⡄⠀⠘⢿⣦⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣤⡀⠀⠀⠀⠀⠀⠀⠈⠛⠿⢿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
		'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠳⠦⠄⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
	},
	opts = {
		position = 'center',
		hl = 'Label',
	},
}

local function button(sc, txt)
	local sc_ = sc:gsub('%s', ''):gsub('SPC', '<leader>')

	local opts = {
		position = 'center',
		text = txt,
		shortcut = sc,
		cursor = 5,
		width = 36,
		align_shortcut = 'right',
	}

	return {
		type = 'button',
		val = txt,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, 'normal', false)
		end,
		opts = opts,
	}
end

sections.buttons = {
	type = 'group',
	val = {
		button('f f', '  Find file  '),
		button('f r', 'ﮦ  Recent files  '),
		button('f g', '  Live grep'),
		button('f m', '  Bookmarks'),
		button('w o', '󰚝  Open Workspace'),
		button(', s', '  Configuration'),
		button('q a', '  Quit'),
	},
	opts = {
		spacing = 1,
	},
}

require('alpha').setup({
	layout = {
		{ type = 'padding', val = fn.max({ 2, fn.floor(fn.winheight(0) * 0.1) }) },
		sections.header,
		{ type = 'padding', val = 1 },
		sections.buttons,
	},
	opts = {},
})

augroup('alpha', { clear = true })

-- Auto-launch alpha when last buffer is closed
autocmd('User', {
	group = 'alpha',
	pattern = 'BDeletePost',
	callback = function(event)
		local found_non_empty_buffer = false

		local buffers = {}
		local len = 0
		for buffer = 1, fn.bufnr('$') do
			if fn.buflisted(buffer) == 1 then
				len = len + 1
				buffers[len] = buffer
			end
		end

		for _, bufnr in ipairs(buffers) do
			if not found_non_empty_buffer then
				local name = vim.api.nvim_buf_get_name(bufnr)
				local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

				if
						bufnr ~= event.buf
						and name ~= ''
						and ft ~= 'alpha'
						and not string.match(ft, 'dap')
				then
					found_non_empty_buffer = true
				end
			end
		end

		if not found_non_empty_buffer then
			vim.api.nvim_command('Neotree close')
			vim.api.nvim_command('SymbolsOutlineClose')
			vim.api.nvim_command('lua require("dapui").close()')
			vim.api.nvim_command('lua CloseHorizontalTerminal()')
			vim.api.nvim_command('lua require("dap").repl.close()')
			vim.api.nvim_command('Alpha')
		end
	end,
})

----------------------------------
--      auto-session config
----------------------------------
require('auto-session').setup({
	auto_session_suppress_dirs = { '~' },
})

----------------------------------
--     better-escape config
----------------------------------
require('better_escape').setup()

----------------------------------
--       bufferline config
----------------------------------
require('bufferline').setup({
	options = {
		always_show_bufferline = true,
		buffer_close_icon = '',
		close_icon = '',
		custom_filter = function(buf_number, buf_numbers)
			if vim.bo[buf_number].filetype ~= 'dap-repl' then
				return true
			end
		end,
		diagnostics = false,
		enforce_regular_tabs = false,
		left_trunc_marker = '',
		max_name_length = 14,
		max_prefix_length = 13,
		modified_icon = '',
		offsets = { { filetype = 'neo-tree', padding = 1 } },
		right_trunc_marker = '',
		separator_style = 'thin',
		show_close_icon = false,
		show_tab_indicators = true,
		show_buffer_close_icons = true,
		tab_size = 20,
		themable = true,
		view = 'multiwindow',
	},
})

----------------------------------
--        ChatGPT config
----------------------------------
require('chatgpt').setup({
	api_key_cmd = 'cat ~/.config/.openai_api_key',
})

----------------------------------
--        Comment config
----------------------------------
require('Comment').setup()

----------------------------------
--          dap config
----------------------------------
augroup('dap', { clear = true })

-- Auto-open DAP UI on events
local dap, dapui = require('dap'), require('dapui')

dap.listeners.after.event_initialized['dapui_config'] = function()
	dapui.open('sidebar')
end

dap.listeners.before.event_terminated['dapui_config'] = function()
	dap.repl.close('sidebar')
	dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
	dap.repl.close('sidebar')
	dapui.close()
end

-- Auto-close the DAP repl
dap.listeners.before.event_terminated['dap_repl_terminal'] = function()
	dap.repl.close()
end
dap.listeners.before.event_exited['dap_repl_terminal'] = function()
	dap.repl.close()
end

-- Gutter symbols
fn.sign_define('DapBreakpoint', {
	text = '',
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl = 'DapBreakpoint',
})

fn.sign_define('DapBreakpointCondition', {
	text = 'ﳁ',
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl = 'DapBreakpoint',
})

fn.sign_define('DapBreakpointRejected', {
	text = '',
	texthl = 'DapBreakpoint',
	linehl = 'DapBreakpoint',
	numhl = 'DapBreakpoint',
})

fn.sign_define('DapLogPoint', {
	text = '',
	texthl = 'DapLogPoint',
	linehl = 'DapLogPoint',
	numhl = 'DapLogPoint',
})

fn.sign_define('DapStopped', {
	text = '',
	texthl = 'DapStopped',
	linehl = 'DapStopped',
	numhl = 'DapStopped',
})

dapui.setup({
	layouts = {
		{
			elements = {
				{ id = 'watches',     size = 0.1 },
				{ id = 'breakpoints', size = 0.2 },
				{ id = 'stacks',      size = 0.2 },
				{ id = 'scopes',      size = 0.5 },
			},
			size = 25,
			position = 'right',
		},
		{
			elements = {
				{ id = 'console', size = 0.6 },
				{ id = 'repl',    size = 0.4 },
			},
			size = 11,
			position = 'bottom',
		},
	},
})

require('dap-python').setup()

require('nvim-dap-virtual-text').setup({
	commented = true,
})

require('mason-nvim-dap').setup({
	automatic_installation = true,
})

----------------------------------
--      fidget.nvim config
----------------------------------
require('fidget').setup({})

----------------------------------
--     fine-cmdline config
----------------------------------

require('fine-cmdline').setup({
	cmdline = {
		prompt = '❯ ',
	},
	popup = {
		buf_options = {
			filetype = 'FineCmdlinePrompt',
		},
		position = {
			row = '100%',
		},
		size = {
			width = '100%',
		},
	},
})

----------------------------------
--        fm-nvim config
----------------------------------
require('fm-nvim').setup({
	cmds = {
		fzf_cmd = 'fzf --ansi --color="bg+:'
				.. colors.surface0
				.. ',border:'
				.. colors.blue
				.. ',fg+:'
				.. colors.text
				.. ',prompt:'
				.. colors.flamingo
				.. ',gutter:'
				.. colors.base
				..
				'" --layout="reverse" --padding="0%,0%,5%" --prompt="  " --no-info --pointer="  " --preview-window="right:66%" --preview-window="border-left" --preview="bat --plain --color=always {}"',
	},
	ui = {
		float = {
			border = { '', '─', '', '', '', '', '', '' },
			width = 1.0,
			height = 0.53,
			x = 0,
			y = 0.95,
		},
	},
})

----------------------------------
--       formatter config
----------------------------------

-- This setup call sets up the Format command used below, which just
-- calls the command specified by formatter's defaults
require('formatter').setup({
	-- All formatter configurations are opt-in
	filetype = {
		css = {
			require('formatter.defaults.prettier'),
		},
		html = {
			require('formatter.defaults.prettier'),
		},
		js = {
			require('formatter.defaults.prettier'),
		},
		jsx = {
			require('formatter.defaults.prettier'),
		},
		json = {
			require('formatter.defaults.prettier'),
		},
		less = {
			require('formatter.defaults.prettier'),
		},
		lua = {
			require('formatter.filetypes.lua').stylua,
		},
		markdown = {
			require('formatter.defaults.prettier'),
		},
		python = {
			require('formatter.filetypes.python').black,
		},
		rust = {
			require('formatter.filetypes.rust').rustfmt,
		},
		scss = {
			require('formatter.defaults.prettier'),
		},
		ts = {
			require('formatter.defaults.prettier'),
		},
		typescriptreact = {
			require('formatter.defaults.prettier'),
		},
		yaml = {
			require('formatter.defaults.prettier'),
		},
	},
})

-- This table defines formatters and the filetypes they handle
-- as well as a format function. The function should return true
-- for success and false for failure.
local formatters = {
	black = {
		name = 'black',
		ft = { 'python' },
		format = function()
			if vim.fn.executable('black') == 1 then
				vim.api.nvim_command('Format')
				return true
			end
			return false
		end,
	},
	prettier = {
		name = 'prettier',
		ft = {
			'css',
			'html',
			'js',
			'jsx',
			'json',
			'less',
			'markdown',
			'scss',
			'ts',
			'typescript',
			'typescriptreact',
			'yaml',
		},
		format = function()
			if vim.fn.executable('prettier') == 1 then
				vim.api.nvim_command('Format')
				return true
			end
			return false
		end,
	},
	rustfmt = {
		name = 'rustfmt',
		ft = { 'rust' },
		format = function()
			if vim.fn.executable('rustfmt') == 1 then
				vim.api.nvim_command('Format')
				return true
			end
			return false
		end,
	},
	stylua = {
		name = 'stylua',
		ft = { 'lua' },
		format = function()
			if vim.fn.executable('stylua') == 1 then
				vim.api.nvim_command('Format')
				return true
			end
			return false
		end,
	},
}

local function format_notify(ft, formatter_name, format_success, format_source)
	if format_success then
		notify('Formatted with ' .. format_source, 'info', lionvim_notify_options)
		return
	end

	local notify_string = ''

	if formatter_name ~= nil then
		notify_string = formatter_name .. ' executable not found'
	else
		notify_string = 'No registered formatter for ' .. ft
	end

	notify(
		'Format failed. '
		.. notify_string
		.. ' and no LSP server installed.\n\nTry installing an LSP server with :LspInstall',
		'error',
		lionvim_notify_options
	)
end

-- Formats using formatter.nvim if the current buffer's filetype is in
-- one of the table entries above, otherwise fallback to LSP formatting.
function Format()
	local ft = vim.api.nvim_buf_get_option(0, 'filetype')
	local formatter_name = nil
	local format_success = false
	local format_source = nil

	for _, formatter in pairs(formatters) do
		for _, registered_ft in pairs(formatter.ft) do
			if ft == registered_ft then
				format_success = formatter.format()

				if format_success then
					format_source = formatter.name
				end

				formatter_name = formatter.name
			end
		end
	end

	if not format_success then
		local lsp_name = GetLspClientName()

		if lsp_name ~= nil then
			format_success = true
			format_source = lsp_name
			vim.api.nvim_command('lua vim.lsp.buf.format()')
		end
	end
	if g.SHOW_NOTIFICATION_ON_FORMAT then
		format_notify(ft, formatter_name, format_success, format_source)
	end
end

-- Autoformat on save

augroup('format', { clear = true })
autocmd('BufWritePost', {
	desc = 'Auto-format on save',
	group = 'format',
	callback = function()
		if g.ENABLE_FORMAT_ON_SAVE then
			cmd('lua Format()')
		end
	end,
})

----------------------------------
--       gitsigns config
----------------------------------
require('gitsigns').setup({})

----------------------------------
--         leap config
-----------------------------------

require('leap').add_default_mappings()

----------------------------------
--          LSP config
----------------------------------
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local on_attach = function(client, bufnr)
	g.code_action_menu_show_details = false
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', '<cmd>lua.vim.lsp.omnifunc')

	nmap_buf(bufnr, 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
	nmap_buf(bufnr, 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	nmap_buf(bufnr, 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
	nmap_buf(bufnr, '<space>i', '<cmd>lua vim.lsp.buf.hover()<cr>')
	nmap_buf(bufnr, '<space>h', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
	nmap_buf(bufnr, '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
	nmap_buf(bufnr, '<space>f', '<cmd>Lspsaga lsp_finder<cr>')
	nmap_buf(
		bufnr,
		'<space>wa',
		'<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>'
	)
	nmap_buf(
		bufnr,
		'<space>wr',
		'<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>'
	)
	nmap_buf(
		bufnr,
		'<space>wl',
		'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>'
	)
	nmap_buf(bufnr, '<space>a', '<cmd>Lspsaga code_action<cr>')
	nmap_buf(bufnr, 'rn', '<cmd>Lspsaga rename<cr>')

	-- goto-preview mappings
	nmap_buf(bufnr, 'gp', '<cmd>Lspsaga peek_definition<cr>')
	nmap_buf(
		bufnr,
		'gpi',
		'<cmd>lua require("goto-preview").goto_preview_implementation()<cr>'
	)
	nmap_buf(
		bufnr,
		'gR',
		'<cmd>lua require("goto-preview").goto_preview_references()<cr>'
	)

	-- symbols-outline mappings
	nmap('<space>s', '<cmd>SymbolsOutline<cr>') -- toggle symbols outline

	-- Trouble mappings
	nmap_buf(bufnr, '<space>t', '<cmd>TroubleToggle workspace_diagnostics<cr>')
	nmap_buf(bufnr, 'gr', '<cmd>TroubleToggle lsp_references<cr>')
end

require('goto-preview').setup()
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require('lspconfig')[server_name].setup({
			on_attach = on_attach,
		})
	end,
})

require('lspsaga').setup({
	symbol_in_winbar = {
		enable = false,
	},
	finder = {
		max_height = 0.5,
		min_width = 30,
		force_max_height = false,
		keys = {
			jump_to = 'g',
			expand_or_jump = 'o',
			vsplit = 'v',
			split = 'h',
			tabe = 't',
			tabnew = 'r',
			quit = { 'q', '<ESC>' },
			close_in_preview = '<ESC>',
		},
	},
})

----------------------------------
--       lualine config
----------------------------------
local lualine = require('lualine')

local conditions = {
	buffer_not_empty = function()
		return fn.empty(fn.expand('%<cmd>t')) ~= 1
	end,
	hide_in_width = function()
		return fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = fn.expand('%<cmd>p:h')
		local gitdir = fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
		-- Disable sections and component separators
		component_separators = '',
		disabled_filetypes = {
			'alpha',
			'dap-repl',
			'dapui_breakpoints',
			'dapui_console',
			'dapui_hover',
			'dapui_repl',
			'dapui_stacks',
			'dapui_scopes',
			'dapui_watches',
			'FineCmdlinePrompt',
			'Fm',
			'neo-tree',
			'oil',
			'Outline',
			'Searchbox',
			'TelescopePrompt',
			'toggleterm',
			'Trouble',
		},
		globalstatus = true,
		section_separators = '',
		theme = {
			normal = { c = { bg = colors.crust } },
			inactive = { c = { bg = colors.crust } },
		},
	},
	sections = {
		-- These are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- These are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return '▌'
	end,
	color = { fg = colors.lavender }, -- Sets highlighting of component
	padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({
	-- mode component
	function()
		return ''
	end,
	color = function()
		-- auto change color according to neovims mode
		local mode_color = {
			n = colors.red,
			i = colors.green,
			v = colors.blue,
			V = colors.blue,
			c = colors.mauve,
			no = colors.red,
			s = colors.peach,
			S = colors.peach,
			[''] = colors.peach,
			ic = colors.yellow,
			R = colors.lavender,
			Rv = colors.lavender,
			cv = colors.red,
			ce = colors.red,
			r = colors.teal,
			rm = colors.teal,
			['r?'] = colors.teal,
			['!'] = colors.red,
			t = colors.red,
		}
		return { fg = mode_color[fn.mode()] }
	end,
	padding = { right = 1 },
})

ins_left({
	'filename',
	cond = conditions.buffer_not_empty,
	icon = '',
	color = function()
		if vim.api.nvim_buf_get_option(0, 'modified') then
			return { fg = colors.red, gui = 'bold' }
		end
		return { fg = colors.blue, gui = 'bold' }
	end,
})

ins_left({
	'branch',
	icon = '',
	color = { fg = colors.lavender, gui = 'bold' },
})

ins_left({
	'filesize',
	cond = conditions.buffer_not_empty,
	icon = '',
})

ins_left({
	'location',
	icon = '',
})

ins_right({
	'diff',
	symbols = { added = ' ', modified = '柳', removed = ' ' },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.peach },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_right({
	-- Filetype
	function()
		return vim.api.nvim_buf_get_option(0, 'filetype')
	end,
	icon = '',
	color = function()
		local lsp_client = GetLspClientName()

		if lsp_client == nil then
			return { fg = colors.red }
		end

		return { fg = colors.green, gui = 'bold' }
	end,
})

ins_right({
	'diagnostics',
	sources = { 'nvim_diagnostic' },
	symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.teal },
	},
})

ins_right({
	function()
		return '▐'
	end,
	color = { fg = colors.lavender },
	padding = { left = 1 },
})

lualine.setup(config)

----------------------------------
--      muren.nvim config
----------------------------------
require('muren').setup()

----------------------------------
--       neo-tree config
----------------------------------
require('neo-tree').setup({
	close_if_last_window = true,
	default_component_configs = {
		git_status = {
			symbols = {
				added = '',
				modified = '',
				deleted = '',
				renamed = '',
				untracked = '?',
				ignored = '',
				unstaged = '',
				staged = '',
				conflict = '',
			},
		},
		name = {
			use_git_status_colors = false,
		},
	},
	filesystem = {
		hide_dotfiles = false,
	},
	window = {
		width = 32,
	},
	source_selector = {
		sources = {
			{ source = 'filesystem', display_name = ' 󰉓 Files ' },
			{ source = 'buffers', display_name = '  Bufs ' },
			{ source = 'git_status', display_name = ' 󰊢 Git ' },
		},
		winbar = true,
	},
})

augroup('neotree_start', { clear = true })
autocmd('VimEnter', {
	desc = 'Open Neo-Tree on startup',
	group = 'neotree_start',
	callback = function()
		if g.show_neotree_on_startup then
			cmd('Neotree show')
		end
	end,
})

----------------------------------
--    nvim-autopairs config
----------------------------------
require('nvim-autopairs').setup({})

----------------------------------
--       nvim-cmp config
----------------------------------
require('luasnip.loaders.from_vscode').lazy_load()

local luasnip = require('luasnip')
local cmp = require('cmp')

local kind_icons = {
	Text = '',
	Method = '',
	Function = '',
	Constructor = '',
	Field = '',
	Variable = '',
	Class = 'ﴯ',
	Interface = '',
	Module = '',
	Property = 'ﰠ',
	Unit = '',
	Value = '',
	Enum = '',
	Keyword = '',
	Snippet = '',
	Color = '',
	File = '',
	Reference = '',
	Folder = '',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = '',
	Operator = '',
	TypeParameter = '',
	Copilot = '',
}

cmp.setup({
	enabled = function()
		-- disable completion in comments
		local context = require('cmp.config.context')
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == 'c' then
			return true
		else
			return not context.in_treesitter_capture('comment')
					and not context.in_syntax_group('Comment')
		end
	end,
	formatting = {
		format = function(_, vim_item)
			vim_item.kind =
					string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 'c' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 'c' }),
		['<cr>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
})

cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' },
	}, {
		{ name = 'buffer' },
	}),
})

local cmp_disabled_filetypes = {
	'dap-repl',
	'dapui_console',
	'FineCmdlinePrompt',
	'Searchbox',
	'TelescopePrompt',
	'oil',
}

for _, filetype in pairs(cmp_disabled_filetypes) do
	cmp.setup.filetype(filetype, {
		enabled = false,
	})
end

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

----------------------------------
--    nvim-treesitter config
----------------------------------
require('nvim-ts-autotag').setup()
require('nvim-treesitter.configs').setup({
	auto_install = true,
	ensure_installed = {
		'c',
		'cpp',
		'css',
		'html',
		'java',
		'javascript',
		'lua',
		'python',
		'typescript',
		'rust',
		'yaml',
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = ']',
			node_incremental = ']',
			node_decremental = '[',
		},
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
	},
})

----------------------------------
--         oil config
----------------------------------
require('oil').setup()

----------------------------------
--      paperplanes config
----------------------------------
require('paperplanes').setup({
	register = '+',
	provider = 'ix.io',
	provider_options = { insecure = true },
	cmd = 'curl',
})

----------------------------------
--       peek.nvim config
----------------------------------
require('peek').setup({
	-- auto_load through peek wasn't working for me so I created my own
	-- autocmd below.
	auto_load = false,
})

augroup('peek', { clear = true })
autocmd('BufEnter', {
	desc = 'Open peek on entering a markdown buffer',
	group = 'peek',
	callback = function()
		if not g.auto_open_markdown_previews then
			return
		end

		local peek = require('peek')
		local ft = vim.api.nvim_buf_get_option(0, 'filetype')
		if ft == 'markdown' and not peek.is_open() then
			peek.open()
		end
	end,
})

----------------------------------
--   searchbox.nvim config
----------------------------------
require('searchbox').setup({
	popup = {
		buf_options = {
			filetype = 'Searchbox',
		},
		position = {
			row = '0%',
		},
	},
})

----------------------------------
--        sniprun config
----------------------------------
require('sniprun').setup({
	display = {
		'TempFloatingWindow',
	},
	live_mode_toggle = 'enable',
})

----------------------------------
--    symbols-outline config
----------------------------------
g.symbols_outline = {
	width = 25,
	relative_width = false,
	show_symbol_details = false,
	window_bg_highlight = 'Pmenu',
	keymaps = {
		focus_location = 'f',
		hover_symbol = 'i',
		toggle_preview = 'p',
	},
	symbols = {
		Array = { icon = '', hl = 'TSConstant' },
		Boolean = { icon = '⊨', hl = 'TSBoolean' },
		Class = { icon = 'ﴯ', hl = 'TSType' },
		Constant = { icon = '', hl = 'TSConstant' },
		Constructor = { icon = '', hl = 'TSConstructor' },
		Enum = { icon = '', hl = 'TSType' },
		EnumMember = { icon = '', hl = 'TSField' },
		Event = { icon = '', hl = 'TSType' },
		Field = { icon = '', hl = 'TSField' },
		File = { icon = '', hl = 'TSURI' },
		Function = { icon = '', hl = 'TSFunction' },
		Interface = { icon = '', hl = 'TSType' },
		Key = { icon = '', hl = 'TSType' },
		Method = { icon = '', hl = 'TSMethod' },
		Module = { icon = '', hl = 'TSNamespace' },
		Namespace = { icon = '', hl = 'TSNamespace' },
		Null = { icon = 'NULL', hl = 'TSType' },
		Number = { icon = '#', hl = 'TSNumber' },
		Object = { icon = '⦿', hl = 'TSType' },
		Operator = { icon = '', hl = 'TSOperator' },
		Package = { icon = '', hl = 'TSNamespace' },
		Property = { icon = 'ﰠ', hl = 'TSMethod' },
		String = { icon = '', hl = 'TSString' },
		Struct = { icon = '', hl = 'TSType' },
		TypeParameter = { icon = '', hl = 'TSParameter' },
		Variable = { icon = '', hl = 'TSConstant' },
	},
}

----------------------------------
--       Telescope config
----------------------------------
require('telescope').setup({
	defaults = {
		borderchars = {
			prompt = { '─', ' ', ' ', ' ', '─', '─', ' ', ' ' },
			results = { ' ' },
			preview = { ' ', ' ', ' ', '│', '│', ' ', ' ', ' ' },
		},
		color_devicons = true,
		dynamic_preview_title = true,
		entry_prefix = ' ',
		file_ignore_patterns = {
			'^.bundle/',
			'^.git/',
			'^node_modules/',
			'^site-packages/',
		},
		initial_mode = 'insert',
		layout_config = {
			bottom_pane = {
				height = 0.5,
				preview_cutoff = 1,
				preview_width = 0.65,
				prompt_position = 'top',
			},
		},
		layout_strategy = 'bottom_pane',
		path_display = { 'truncate' },
		pickers = {
			find_files = {
				hidden = true,
			},
		},
		prompt_prefix = ' ',
		results_title = false,
		selection_caret = ' ',
		selection_strategy = 'reset',
		sorting_strategy = 'ascending',
		use_less = true,
		vimgrep_arguments = {
			'rg',
			'--column',
			'--hidden',
			'--line-number',
			'--smart-case',
		},
		winblend = 0,
	},
	extensions = {
		cder = {
			dir_command = {
				'fd',
				'--type=d',
				'--exclude=node_modules',
				'--exclude=Library',
				'--exclude=Pictures',
				'--exclude=Music',
				'--exclude=Movies',
				'--exclude=Public',
				'.',
				os.getenv('HOME'),
			},
			previewer_command = 'eza '
					.. '-a '
					.. '--color=always '
					.. '-T '
					.. '--level=3 '
					.. '--icons '
					.. '--git-ignore '
					.. '--long '
					.. '--no-permissions '
					.. '--no-user '
					.. '--no-filesize '
					.. '--git '
					.. '--ignore-glob=.git',
		},
		howdoi = {
			enable_storage = true,
		},
		command_center = {
			components = { require('command_center').component.DESCRIPTION },
			prompt_title = false,
			prompt_prefix = '❯ ',
		},
	},
})

require('telescope').load_extension('cder')
require('telescope').load_extension('command_center')
require('telescope').load_extension('fzf')
require('telescope').load_extension('howdoi')
require('telescope').load_extension('media_files')
require('telescope').load_extension('undo')
require('telescope').load_extension('workspaces')

---------------------------------
--      toggleterm config
---------------------------------
require('toggleterm').setup({
	shade_terminals = false,
})

local Terminal = require('toggleterm.terminal').Terminal

local horizontal = Terminal:new({
	direction = 'horizontal',
	hidden = true,
})

function ToggleHorizontalTerminal()
	horizontal:toggle()
end

function CloseHorizontalTerminal()
	horizontal:close()
end

local vtop = Terminal:new({
	cmd = 'vtop',
	direction = 'float',
	hidden = true,
})

function ToggleVtop()
	vtop:toggle()
end

local lazygit = Terminal:new({
	cmd = 'lazygit',
	direction = 'float',
	hidden = true,
})

function ToggleLazygit()
	lazygit:toggle()
end

local ipython = Terminal:new({
	cmd = 'ipython',
	direction = 'float',
	hidden = true,
})

function ToggleIPython()
	ipython:toggle()
end

----------------------------------
--       trees config
----------------------------------
require('treesj').setup({
	use_default_keymaps = false,
})

--       trouble config
----------------------------------
require('trouble').setup({
	action_keys = {
		close = { 'q', '<F3>' },
		hover = 'i',
	},
	auto_preview = false,
	padding = false,
	use_diagnostic_signs = true,
})

----------------------------------
--    command center config
----------------------------------
local command_center = require('command_center')

command_center.add({
	{
		description = 'Open keymap',
		cmd = '<cmd>WhichKey<cr>',
	},
	{
		description = 'Find file',
		cmd = '<cmd>Telescope find_files<cr>',
	},
	{
		description = 'Open recent file',
		cmd = '<cmd>Telescope oldfiles prompt_title=Recents<cr>',
	},
	{
		description = 'Search in current file',
		cmd =
		'<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ previewer = false, prompt_title = "", layout_config = { height = 40 }}))<cr>',
	},
	{
		description = 'Live grep',
		cmd = '<cmd>Telescope live_grep hidden=true<cr>',
	},
	{
		description = 'Open new file',
		cmd = '<cmd>tabnew<cr>',
	},
	{
		description = 'Change working directory',
		cmd = '<cmd>Telescope cder<cr>',
	},
	{
		description = 'Close current file',
		cmd = '<cmd>Bdelete<cr>',
	},
	{
		description = 'Save current file',
		cmd = '<cmd>w<cr>',
	},
	{
		description = 'Save all files',
		cmd = '<cmd>wa<cr>',
	},
	{
		description = 'Discard changes to current file',
		cmd = '<cmd>e!<cr>',
	},
	{
		description = 'Reload current file',
		cmd = '<cmd>e<cr>',
	},
	{
		description = 'Save and quit',
		cmd = '<cmd>wq<cr>',
	},
	{
		description = 'Quit',
		cmd = '<cmd>qa<cr>',
	},
	{
		description = 'Force quit',
		cmd = '<cmd>q!<cr>',
	},
	{
		description = 'Toggle format on save',
		cmd = '<cmd>lua ToggleFormatOnSave()<cr>',
	},
	{
		description = 'Toggle format notifications',
		cmd = '<cmd>lua ToggleFormatNotifications()<cr>',
	},
	{
		description = 'Open workspace',
		cmd = '<cmd>Telescope workspaces<cr>',
	},
	{
		description = 'Open vertical split',
		cmd = '<cmd>vsp<cr>',
	},
	{
		description = 'Open horizontal split',
		cmd = '<cmd>sp<cr>',
	},
	{
		description = 'Select all',
		cmd = '<cmd>call feedkeys("GVgg")<cr>',
	},
	{
		description = 'Upload buffer to ix.io',
		cmd = '<cmd>PP<cr>',
	},
	{
		description = 'Trim trailing whitespace',
		cmd = '<cmd>%s/\\s\\+$//<cr><cmd>nohlsearch<cr>',
	},
	{
		description = 'Reload config',
		cmd = '<cmd>source ~/.config/nvim/init.lua<cr><cmd>lua notify("Config reloaded", "info", { title = "🦁 Lionvim"})<cr>',
	},
	{
		description = 'Rename symbol under cursor',
		cmd = '<cmd>lua vim.lsp.buf.rename()<cr>',
	},
	{
		description = 'Format file',
		cmd = '<cmd>lua Format()<cr>',
	},
	{
		description = 'Open command history',
		cmd = '<cmd>Telescope command_history<cr>',
	},
	{
		description = 'Open search history',
		cmd = '<cmd>Telescope search_history<cr>',
	},
	{
		description = 'Open jump list',
		cmd = '<cmd>Telescope jumplist<cr>',
	},
	{
		description = 'Open marks',
		cmd = '<cmd>Telescope marks<cr>',
	},
	{
		description = 'Open config',
		cmd = '<cmd>e $MYVIMRC | :cd %:p:h <cr>',
	},
	{
		description = 'Open filetype list',
		cmd = '<cmd>Telescope filetypes<cr>',
	},
	{
		description = 'Open symbol map',
		cmd = '<cmd>Telescope symbols<cr>',
	},
	{
		description = 'Open vim options',
		cmd = '<cmd>Telescope vim_options<cr>',
	},
	{
		description = 'Open man pages',
		cmd = '<cmd>Telescope man_pages<cr>',
	},
	{
		description = 'Open spell suggest',
		cmd = '<cmd>Telescope spell_suggest<cr>',
	},
	{
		description = 'Open git branches',
		cmd = '<cmd>Telescope git_branches<cr>',
	},
	{
		description = 'Open git files',
		cmd = '<cmd>Telescope git_files<cr>',
	},
	{
		description = 'Open git status',
		cmd = '<cmd>Telescope git_status<cr>',
	},
	{
		description = 'Generate gitignore file',
		cmd = '<cmd>Gitignore<cr>',
	},
	{
		description = 'Open quickfix history',
		cmd = '<cmd>Telescope quickfixhistory<cr>',
	},
	{
		description = 'Open type definitions',
		cmd = '<cmd>Telescope lsp_type_definitions<cr>',
	},
	{
		description = 'Open document symbols',
		cmd = '<cmd>Telescope lsp_document_symbols<cr>',
	},
	{
		description = 'Open treesitter',
		cmd = '<cmd>Telescope treesitter<cr>',
	},
	{
		description = 'Open diagnostics',
		cmd = '<cmd>TroubleToggle<cr>',
	},
	{
		description = 'Open quickfix menu',
		cmd = '<cmd>Telescope quickfix<cr>',
	},
	{
		description = 'Open definitions',
		cmd = '<cmd>Telescope lsp_definitions<cr>',
	},
	{
		description = 'Open references',
		cmd = '<cmd>Telescope lsp_references<cr>',
	},
	{
		description = 'Open implementations',
		cmd = '<cmd>Telescope lsp_implementations<cr>',
	},
	{
		description = 'Open dynamic workspace symbols',
		cmd = '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
	},
	{
		description = 'Open DAP commands',
		cmd = '<cmd>Telescope dap commands<cr>',
	},
	{
		description = 'Open DAP configurations',
		cmd = '<cmd>Telescope dap configurations<cr>',
	},
	{
		description = 'Open DAP breakpoints',
		cmd = '<cmd>Telescope dap breakpoints<cr>',
	},
	{
		description = 'Open DAP variables',
		cmd = '<cmd>Telescope dap variables<cr>',
	},
	{
		description = 'Open DAP frames',
		cmd = '<cmd>Telescope dap frames<cr>',
	},
	{
		description = 'Open references for symbol under cursor',
		cmd = '<cmd>lua require("goto-preview").goto_preview_references()<cr>',
	},
	{
		description = 'Open definition for symbol under cursor',
		cmd = '<cmd>lua require("goto-preview").goto_definition()<cr>',
	},
	{
		description = 'Open implementation for symbol under cursor',
		cmd = '<cmd>lua require("goto-preview").goto_implementation()<cr>',
	},
	{
		description = 'Close all preview windows',
		cmd = '<cmd>lua require("goto-preview").close_all_win()<cr>',
	},
	{
		description = 'Change colorscheme',
		cmd =
		'<cmd>lua require("telescope.builtin").colorscheme(require("telescope.themes").get_dropdown({ layout_config = { height = 20 }}))<cr>',
	},
	{
		description = 'Toggle cursor line',
		cmd = '<cmd>set cursorline!<cr>',
	},
	{
		description = 'Toggle spell checker',
		cmd = '<cmd>set spell!<cr>',
	},
	{
		description = 'Toggle relative number',
		cmd = '<cmd>set relativenumber!<cr>',
	},
	{
		description = 'Toggle search highlighting',
		cmd = '<cmd>set hlsearch!<cr>',
	},
	{
		description = 'Toggle live code execution',
		cmd = '<cmd>SnipLive<cr>',
	},
	{
		description = 'Toggle file tree',
		cmd = '<cmd>Neotree toggle<cr>',
	},
	{
		description = 'Toggle symbols outline',
		cmd = '<cmd>SymbolsOutline<cr>',
	},
	{
		description = 'Open floating terminal',
		cmd = '<cmd>ToggleTerm direction=float<cr>',
	},
	{
		description = 'Toggle terminal in horizontal split',
		cmd = '<cmd>lua ToggleHorizontalTerminal()<cr>',
	},
	{
		description = 'Open lazygit',
		cmd = '<cmd>lua ToggleLazygit()<cr>',
	},
	{
		description = 'Open vtop',
		cmd = '<cmd>lua ToggleVtop()<cr>',
	},
	{
		description = 'Open ipython',
		cmd = '<cmd>lua ToggleIPython()<cr>',
	},
	{
		description = 'Install LSP server',
		cmd = '<cmd>LspInstall<cr>',
	},
	{
		description = 'Open LSP info',
		cmd = '<cmd>LspInfo<cr>',
	},
	{
		description = 'Restart LSP server',
		cmd = '<cmd>LspRestart<cr>',
	},
	{
		description = 'Check health',
		cmd = '<cmd>checkhealth<cr>',
	},
	{
		description = 'Lazy install',
		cmd = '<cmd>Lazy cnstall<cr>',
	},
	{
		description = 'Lazy update',
		cmd = '<cmd>Lazy update<cr>',
	},
	{
		description = 'Lazy sync',
		cmd = '<cmd>Lazy sync<cr>',
	},
	{
		description = 'Lazy clean',
		cmd = '<cmd>Lazy clean<cr>',
	},
	{
		description = 'Lazy health',
		cmd = '<cmd>Lazy health<cr>',
	},
	{
		description = 'Start live markdown preview',
		cmd = '<cmd>lua require("peek").open()<cr>',
	},
	{
		description = 'Stop live markdown preview',
		cmd = '<cmd>lua require("peek").close()<cr>',
	},
	{
		description = 'Make it rain',
		cmd = '<cmd>CellularAutomaton make_it_rain<cr>',
	},
	{
		description = 'Play game of life',
		cmd = '<cmd>CellularAutomaton game_of_life<cr>',
	},
	{
		description = 'Edit directory in a buffer',
		cmd = '<cmd>Oil --float .<cr>',
	},
})

----------------------------------
--       which-key config
----------------------------------
local wk = require('which-key')

wk.setup({
	ignore_missing = true,
	plugins = {
		marks = false,
		registers = false,
		presets = {
			operators = false,
			motions = false,
			nav = false,
			g = false,
		},
	},
	key_labels = {
		['<C-C>'] = 'Ctrl + c',
		['<C-B>'] = 'Ctrl + b',
		['<C-H>'] = 'Ctrl + h',
		['<C-J>'] = 'Ctrl + j',
		['<C-K>'] = 'Ctrl + k',
		['<C-L>'] = 'Ctrl + l',
		['<C-F>'] = 'Ctrl + f',
		['<C-N>'] = 'Ctrl + n',
		['<C-O>'] = 'Ctrl + o',
		['<C-Q>'] = 'Ctrl + q',
		['<C-S>'] = 'Ctrl + s',
		['<C-V>'] = 'Ctrl + v',
		['<c-w>'] = 'Ctrl + w',
		['<C-X>'] = 'Ctrl + x',
		['<F1>'] = 'F1',
		['<F2>'] = 'F2',
		['<F3>'] = 'F3',
		['<F4>'] = 'F4',
		['<F5>'] = 'F5',
		['<F6>'] = 'F6',
		['<F7>'] = 'F7',
		['<S-Right>'] = 'Shift + ',
		['<S-Left>'] = 'Shift + ',
		['<S-Up>'] = 'Shift + ',
		['<S-Down>'] = 'Shift + ',
		['<space>'] = 'Space',
		['<leader>'] = ',',
	},
})

wk.register({
	{ "/",               desc = "Search" },
	{ "<F1>",            desc = "Goto previous location" },
	{ "<F2>",            desc = "Goto next location" },
	{ "<F4>",            desc = "Search man pages" },
	{ "<F5>",            desc = "Search help tags" },
	{ "<F6>",            desc = "Open verbose keymap" },
	{ "<c-b>",           desc = "Toggle DAP UI" },
	{ "<c-c>",           desc = "Edit directory in buffer" },
	{ "<c-f>",           desc = "Toggle file tree" },
	{ "<c-h>",           desc = "Go to window left" },
	{ "<c-j>",           desc = "Go to window down" },
	{ "<c-k>",           desc = "Go to window up" },
	{ "<c-l>",           desc = "Go to window right" },
	{ "<c-n>",           desc = "New file" },
	{ "<c-o>",           desc = "Open file" },
	{ "<c-q>",           desc = "Close focused window" },
	{ "<c-s>",           desc = "Save current buffer" },
	{ "<c-v>",           desc = "Split window vertically" },
	{ "<c-x>",           desc = "Split window horizontally" },
	{ "<leader>",        group = "Misc" },
	{ "<leader><space>", desc = "Toggle search results highlight" },
	{ "<leader>b",       desc = "Toggle git blame" },
	{ "<leader>c",       desc = "Open ChatGPT" },
	{ "<leader>g",       desc = "Toggle lazygit" },
	{ "<leader>i",       desc = "Toggle ipython" },
	{ "<leader>j",       desc = "Toggle spliting/joining code block" },
	{ "<leader>l",       desc = "Change colorscheme" },
	{ "<leader>n",       group = "Show notes command palette" },
	{ "<leader>nd",      desc = "Go to today's note" },
	{ "<leader>nf",      desc = "Search for a note by title" },
	{ "<leader>ni",      desc = "Paste an image and insert link" },
	{ "<leader>nl",      desc = "Insert a link to a note" },
	{ "<leader>nn",      desc = "Create a new note" },
	{ "<leader>ns",      desc = "Search within notes" },
	{ "<leader>p",       desc = "Upload buffer to ix.io" },
	{ "<leader>s",       desc = "Open nvim config" },
	{ "<leader>t",       desc = "Toggle floating terminal" },
	{ "<leader>u",       desc = "Toggle undo tree" },
	{ "<leader>v",       desc = "Toggle vtop" },
	{ "<leader>x",       desc = "Toggle horizontal terminal" },
	{ "<s-down>",        desc = "Move line down" },
	{ "<s-left>",        desc = "Move buffer left" },
	{ "<s-right>",       desc = "Move buffer right" },
	{ "<s-up>",          desc = "Move line up" },
	{ "<space>",         group = "Util" },
	{ "<space>a",        desc = "Open code action menu" },
	{ "<space>c",        desc = "Open command palette" },
	{ "<space>d",        desc = "Open type definition for symbol" },
	{ "<space>f",        desc = "Open finder for symbol" },
	{ "<space>h",        desc = "Open signature help" },
	{ "<space>i",        desc = "Preview symbol information" },
	{ "<space>o",        desc = "Toggle function outline" },
	{ "<space>s",        desc = "Toggle symbol outline" },
	{ "<space>t",        desc = "Toggle diagnostics menu" },
	{ "<space>w",        group = "Workspace" },
	{ "<space>wa",       desc = "Add workspace folder" },
	{ "<space>wl",       desc = "List workspace folders" },
	{ "<space>wr",       desc = "Remove workspace folder" },
	{ "?",               desc = "Open keymap" },
	{ "S",               desc = "Jump to text backwards" },
	{ "[",               desc = "Decrement node selection" },
	{ "]",               desc = "Increment node selection" },
	{ "b",               group = "Debug" },
	{ "bO",              desc = "Step out" },
	{ "bb",              desc = "Toggle breakpoint" },
	{ "bc",              desc = "Continue" },
	{ "be",              desc = "Evaluate expression under cursor" },
	{ "bf",              desc = "List frames" },
	{ "bi",              desc = "Step into" },
	{ "bl",              desc = "List breakpoints" },
	{ "bo",              desc = "Step over" },
	{ "bt",              desc = "Terminate" },
	{ "bv",              desc = "List variables" },
	{ "cac",             desc = "a class" },
	{ "caf",             desc = "a function" },
	{ "cd",              desc = "Change working directory" },
	{ "cic",             desc = "a class" },
	{ "cif",             desc = "a function" },
	{ "cs",              desc = "Change surrounding" },
	{ "d",               group = "Delete" },
	{ "da",              group = "Text objects" },
	{ "dac",             desc = "a class" },
	{ "daf",             desc = "a function" },
	{ "dic",             desc = "a class" },
	{ "dif",             desc = "a function" },
	{ "ds",              desc = "Surrounding" },
	{ "e",               group = "Code execution" },
	{ "ec",              desc = "Clear all execution results" },
	{ "el",              desc = "Toggle live code execution" },
	{ "eq",              desc = "Stop currently executing code" },
	{ "er",              desc = "Execute current line" },
	{ "f",               group = "Search" },
	{ "fb",              desc = "Search open buffer names" },
	{ "ff",              desc = "Search for filename" },
	{ "fg",              desc = "Live grep" },
	{ "fh",              desc = "Search howdoi" },
	{ "fr",              desc = "Search for recent file" },
	{ "fs",              desc = "Search for symbol" },
	{ "fw",              desc = "Search pattern in current file" },
	{ "fz",              desc = "Search for filename with fzf" },
	{ "g",               group = "Goto/Comments" },
	{ "gD",              desc = "Goto declaration for symbol" },
	{ "gP",              desc = "Close all definition preview windows" },
	{ "gR",              desc = "Search references for symbol" },
	{ "gb",              desc = "Toggle comment blockwise" },
	{ "gc",              desc = "Toggle comment linewise" },
	{ "gcac",            desc = "a class" },
	{ "gcaf",            desc = "a function" },
	{ "gcc",             desc = "Toggle comment for current line" },
	{ "gcic",            desc = "a class" },
	{ "gcif",            desc = "a function" },
	{ "gd",              desc = "Goto definition for symbol" },
	{ "gi",              desc = "Goto implementation for symbol" },
	{ "go",              desc = "Goto header/implementation file" },
	{ "gp",              desc = "Open definition preview for symbol" },
	{ "gr",              desc = "Open references for symbol in quickfix" },
	{ "gs",              desc = "Switch symbol under cursor" },
	{ "q",               group = "Quit" },
	{ "qa",              desc = "Quit all without saving" },
	{ "qf",              desc = "Force quit without saving" },
	{ "qq",              desc = "Close current buffer" },
	{ "qs",              desc = "Save all and quit" },
	{ "qw",              desc = "Save and quit" },
	{ "r",               group = "Refactor" },
	{ "rf",              desc = "Format file" },
	{ "rg",              desc = "Replace all" },
	{ "rl",              desc = "Replace on line only" },
	{ "rn",              desc = "Rename symbol under cursor" },
	{ "rs",              desc = "Replace multiple patterns" },
	{ "rt",              group = "Trim" },
	{ "rtm",             desc = "Trim trailing whitespace" },
	{ "rtw",             desc = "Trim ^M carriage characters" },
	{ "rw",              desc = "Replace word under cursor" },
	{ "s",               desc = "Jump to text forwards" },
	{ "v",               group = "Visual Mode" },
	{ "vr",              desc = "Execute code selection" },
	{ "w",               group = "Jump" },
	{ "wo",              desc = "Open workspace" },
	{ "ws",              desc = "Jump to text in any window" },
	{ "ww",              desc = "Jump to buffer" },
})


----------------------------------
--      workspaces config
----------------------------------
require('workspaces').setup({
	hooks = {
		open = { 'Telescope oldfiles prompt_title=Recents' },
	},
})
