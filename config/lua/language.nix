{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {formatters_by_ft.lua = ["stylua"];};
    };
    lsp.servers.lua_ls = {
      enable = true;
    };
    none-ls.sources.formatting.stylua.enable = true;
  };
}
