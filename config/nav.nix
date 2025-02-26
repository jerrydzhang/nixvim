{
plugins = {
fzf-lua = {
enable = true;
keymaps = {
        "<leader><leader>" = {
          action = "files";
          options.desc = "Find File";
        };
        "<leader>," = {
          action = "buffers";
          options.desc = "Switch Buffer";
          settings = {
            sort_mru = true;
            sort_lastused = true;
          };
        };
		"<leader>sg" = {
		  action = "live_grep";
		  options.desc = "Live Grep";
		};
        "<leader>s\"" = {
          action = "registers";
          options.desc = "Registers";
        };
        "<leader>sd" = {
          action = "diagnostics_document";
          options.desc = "Document Diagnostics";
        };
        "<leader>sD" = {
          action = "diagnostics_workspace";
          options.desc = "Workspace Diagnostics";
        };
        "<leader>sk" = {
          action = "keymaps";
          options.desc = "Key Maps";
        };
      };
};
harpoon = {
enable = true;
};
flash = {
enable = true;
};
smart-splits = {
enable = true;
};
};
}
