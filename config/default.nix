{pkgs, ...}: {
  # Import all your configuration modules here
  imports = [
    ./visual.nix
    ./keymap.nix
    ./options.nix
    ./nav.nix
    ./dashboard.nix
    ./text.nix
    ./plugins.nix
    ./markdown/default.nix
    ./python/default.nix
    ./rust/default.nix
  ];

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "copilot-lualine";
      src = pkgs.fetchFromGitHub {
        owner = "AndreM222";
        repo = "copilot-lualine";
        rev = "dc4b8ed0f75bc2557b3158c526624bf04ad233ea";
        hash = "sha256-7FHSSaptU5AQ5nwgB4xOFh1xDQbB3NTqATAvXMr/Shg=";
      };
    })

    (pkgs.vimUtils.buildVimPlugin {
      name = "mini.files";
      src = pkgs.fetchFromGitHub {
        owner = "echasnovski";
        repo = "mini.files";
        rev = "794ac48d6e02c83f683feb3537b0e2074b9daeba";
        hash = "sha256-odj+3tlygQriuYVp2KiOxrQMy4fMix6+t4btR57CpgM=";
      };
    })
  ];
}
