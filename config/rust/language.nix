{
  plugins = {
    bacon.enable = true;
    conform-nvim = {
      enable = true;
      settings = {formatters_by_ft.rust = ["rustfmt"];};
    };
    rustaceanvim = {
      enable = true;
      settings = {
        # server = {
        #   dap.adapters.lldb = {
        #     type = "server";
        #     port = "${''$''}{port}";
        #     executable = {
        #       command = "codelldb";
        #       args = ["--port" "${''$''}{port}"];
        #     };
        #   };
        # };
        tools.enable_clippy = true;
        server = {
          default_settings = {
            inlayHints = {lifetimeElisionHints = {enable = "always";};};
            rust-analyzer = {
              cargo = {allFeatures = true;};
              check = {command = "clippy";};
              files = {excludeDirs = ["target" ".git" ".cargo" ".github" ".direnv"];};
            };
          };
        };
      };
    };
  };
}
