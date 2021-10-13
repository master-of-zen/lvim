-- Neovim
-- =========================================
lvim.format_on_save = false
lvim.leader = " "
lvim.colorscheme = "pablo"
lvim.debug = false
lvim.log.level = "warn"
require("user.neovim").config()

-- Customization
-- =========================================
lvim.builtin.lastplace = { active = false } -- change to false if you are jumping to future
lvim.builtin.tabnine = { active = true } -- change to false if you don't like tabnine
lvim.builtin.persistence = { active = true } -- change to false if you don't want persistence
lvim.builtin.presence = { active = false } -- change to true if you want discord presence
lvim.builtin.orgmode = { active = false } -- change to true if you want orgmode.nvim
lvim.builtin.dap.active = false -- change this to enable/disable debugging
lvim.builtin.fancy_statusline = { active = true } -- change this to enable/disable fancy statusline
lvim.builtin.fancy_bufferline = { active = true } -- change this to enable/disable fancy bufferline
lvim.builtin.lua_dev = { active = true } -- change this to enable/disable folke/lua_dev
lvim.builtin.test_runner = { active = true } -- change this to enable/disable vim-test, ultest
lvim.builtin.cheat = { active = true } -- enable cheat.sh integration
lvim.lsp.diagnostics.virtual_text = false -- remove this line if you want to see inline errors
lvim.builtin.latex = {
  view_method = "skim", -- change to zathura if you are on linux
  preview_exec = "/Applications/Skim.app/Contents/SharedSupport/displayline", -- change this to zathura as well
  rtl_support = true, -- if you want to use xelatex, it's a bit slower but works very well for RTL langs
}
lvim.lsp.automatic_servers_installation = true
lvim.lsp.document_highlight = true
lvim.lsp.code_lens_refresh = true
require("user.builtin").config()

-- StatusLine
-- =========================================
if lvim.builtin.fancy_statusline.active then
  require("user.lualine").config()
end

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  require("user.dap").config()
end

-- Language Specific
-- =========================================
-- NOTE: By default, all null-ls providers are checked on startup.
-- If you want to avoid that or want to only set up the provider
-- when you opening the associated file-type,
-- then you can use filetype plugins for this purpose.
-- https://www.lunarvim.org/languages/#lazy-loading-the-formatter-setup
require("user.null_ls").config()

-- NOTE: if you want to disable the lang server builtin formatter.
-- here's an example to disable formatting in "tsserver" and "jsonls"
-- lvim.lsp.on_attach_callback = function(client, _)
--   if client.name == "tsserver" or client.name == "jsonls" then
--     client.resolved_capabilities.document_formatting = false
--     client.resolved_capabilities.document_range_formatting = false
--   end
-- end
-- https://www.lunarvim.org/languages/#multi-languages-per-formatter
lvim.lsp.override = { "dockerls", "sumneko_lua", "texlab", "tsserver", "rust_analyzer" }
for _, server_name in pairs(lvim.lsp.override) do
  local lsp_installer_servers = require "nvim-lsp-installer.servers"
  local server_available, requested_server = lsp_installer_servers.get_server(server_name)
  if server_available then
    if not requested_server:is_installed() then
      if lvim.lsp.automatic_servers_installation then
        requested_server:install()
      else
        return
      end
    end
  end

  local default_config = {
    on_attach = require("lvim.lsp").common_on_attach,
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
  }

  local status_ok, custom_config = pcall(require, "user/providers/" .. requested_server.name)
  if status_ok then
    local new_config = vim.tbl_deep_extend("force", default_config, custom_config)
    requested_server:setup(new_config)
  else
    requested_server:setup(default_config)
  end
end

-- Additional Plugins
-- =========================================
require("user.plugins").config()

-- Autocommands
-- =========================================
require("user.autocommands").config()

-- Additional keybindings
-- =========================================
require("user.keybindings").config()
