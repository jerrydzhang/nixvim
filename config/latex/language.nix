{
  plugins = {
    vimtex = {
      enable = true;
      mupdfPackage = null;
      settings = {
        viewer = "zathura";
      };
    };
    lsp.servers.texlab = {
      enable = true;
    };
  };
}
