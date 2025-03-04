{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          rust = ["rustfmt"];
        };
      };
    };
    lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = true;
      installRustc = true;
      settings = {
        checkOnSave = true;
        check = {
          command = "clippy";
        };
        inlayHints = {
          enable = true;
          showParameterNames = true;
          parameterHintsPrefix = "<- ";
          otherHintsPrefix = "=> ";
        };
        procMacro = {
          enable = true;
        };
        files = {
          exclude = [
            "**/target/**"
            "**/.git/**"
            "**/.direnv/**"
          ];
        };
      };
    };
  };
}
