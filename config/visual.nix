let
  colors = {
    blue = "#8aadf4";
    green = "#a9da95";
    mauve = "#c6a0f6";
    red = "#ed8796";
    yellow = "#eed49f";
    text = "#cad3f5";
    text2 = "#cad3f4";
    peach = "#f5a97f";
    sapphire = "#7dc4e4";
    trans = "nil";
  };
in {
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      custom_highlights = ''
        function(highlights)
          return {
          CustomIblIndent = { fg = highlights.overlay1, style = {} },
          }
        end
      '';
    };
  };
  highlightOverride = {
    LineNrAbove = {
      fg = "#bac2de";
      bold = true;
    };
    LineNr = {
      fg = "#bac2de";
      bold = true;
    };
    LineNrBelow = {
      fg = "#bac2de";
      bold = true;
    };
  };
  plugins = {
    which-key = {
      enable = true;
    };
    transparent = {
      enable = true;
      settings = {
        extra_groups = [
          "WhichKeyValue"
          "WhichKeyIconPurple"
          "WhichKeyIconOrange"
          "WhichKeyIconGrey"
          "WhichKeyIconGreen"
          "WhichKeyIconCyan"
          "WhichKeyIconBlue"
          "WhichKeyIconAzure"
          "WhichKeyIcon"
          "WhichKeyBorder"
          "WhichKeyDesc"
          "WhichKeyGroup"
          "WhichKeySeparator"
          "WhichKeyIconRed"
          "WhichKeyIconYellow"
          "WhichKey"
          "WhichKeyNormal"
          "WhichKeyTitle"
          "MiniFilesNormal"
          "CustomIblIndent"
          "IblIndent"
        ];
      };
    };
    web-devicons = {
      enable = true;
    };
    lualine = {
      enable = true;
      settings = {
        options = {
          component_separators = {
            left = "|";
            right = "|";
          };
          section_separators = {
            left = "||";
            right = "||";
          };
          theme = {
            normal = {
              a = {
                fg = colors.blue;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
            insert = {
              a = {
                fg = colors.green;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
            visual = {
              a = {
                fg = colors.mauve;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
            replace = {
              a = {
                fg = colors.yellow;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
            command = {
              a = {
                fg = colors.red;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
            inactive = {
              a = {
                fg = colors.text;
                bg = colors.trans;
                gui = "bold";
              };
              b = {
                fg = colors.peach;
                bg = colors.trans;
                gui = "bold";
              };
              c = {
                fg = colors.text;
                bg = colors.trans;
              };
            };
          };
        };

        sections = {
          lualine_a = ["mode"];
          lualine_b = ["filename"];
          lualine_c = ["branch" "diagnostics"];
          lualine_x = ["copilot" "vim.lsp.buf_get_clients()[1].name" "filetype"];
          lualine_y = ["progress"];
          lualine_z = ["location"];
        };
        inactive_sections = {
          lualine_a = [];
          lualine_b = [];
          lualine_c = ["filename"];
          lualine_x = ["location"];
          lualine_y = [];
          lualine_z = [];
        };
      };
    };
    fidget = {
      enable = true;
      settings = {
        notification = {
          window = {
            winblend = 0;
          };
        };
      };
    };
    gitsigns.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        indent.highlight = "CustomIblIndent";
      };
    };
  };
}
