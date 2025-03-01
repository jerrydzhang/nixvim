{pkgs, ...}: {
  plugins = {
    vimtex = {
      enable = true;
      mupdfPackage = null;
      texlivePackage = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          scheme-medium
          exam
          ;
      };
      settings = {
        viewer = "zathura";
      };
    };
    lsp.servers.texlab = {
      enable = true;
    };
  };
}
