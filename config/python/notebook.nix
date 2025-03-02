{
  keymaps = [
    {
      mode = "n";
      key = "<localleader>mi";
      action = "<cmd>MoltenInit<CR>";
      options = {
        silent = true;
        desc = "Initialize the plugin";
      };
    }
    {
      mode = "n";
      key = "<localleader>me";
      action = "<cmd>MoltenEvaluateOperator<CR>";
      options = {
        silent = true;
        desc = "run operator selection";
      };
    }
    {
      mode = "n";
      key = "<localleader>mo";
      action = "<cmd>MoltenEnterOutput<CR>";
      options = {
        silent = true;
        desc = "enter molten output";
      };
    }
    {
      mode = "n";
      key = "<localleader>ml";
      action = "<cmd>MoltenEvaluateLine<CR>";
      options = {
        silent = true;
        desc = "evaluate line";
      };
    }
    {
      mode = "n";
      key = "<localleader>mr";
      action = "<cmd>MoltenReevaluateCell<CR>";
      options = {
        silent = true;
        desc = "re-evaluate cell";
      };
    }
    {
      mode = "v";
      key = "<localleader>me";
      action = "<cmd><C-u>MoltenEvaluateVisual<CR>gv";
      options = {
        silent = true;
        desc = "evaluate visual selection";
      };
    }
    {
      mode = "n";
      key = "<localleader>rc";
      action = ''<cmd>lua require("quarto.runner").run_cell'';
      options = {
        desc = "run cell";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<localleader>ra";
      action = ''<cmd>lua require("quarto.runner").run_above'';
      options = {
        desc = "run cell and above";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<localleader>rA";
      action = ''<cmd>lua require("quarto.runner").run_all'';
      options = {
        desc = "run all cells";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<localleader>rl";
      action = ''<cmd>lua require("quarto.runner").run_line'';
      options = {
        desc = "run line";
        silent = true;
      };
    }
    {
      mode = "v";
      key = "<localleader>r";
      action = ''<cmd>lua require("quarto.runner")runner.run_range'';
      options = {
        desc = "run visual range";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<localleader>RA";
      action = ''<cmd>lua require("quarto.runner").run_all(true)'';
      options = {
        desc = "run line";
        silent = true;
      };
    }
  ];
  plugins = {
    molten = {
      enable = true;
      python3Dependencies = p:
        with p; [
          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
          pnglatex
          plotly
          kaleido
          pyperclip
        ];

      # Configuration settings for molten.nvim. More examples at https://github.com/nix-community/nixvim/blob/main/plugins/by-name/molten/default.nix#L191
      settings = {
        auto_image_popup = false;
        auto_init_behavior = "init";
        auto_open_html_in_browser = false;
        auto_open_output = false;
        cover_empty_lines = false;
        copy_output = false;
        enter_output_behavior = "open_then_enter";
        image_provider = "image.nvim";
        output_crop_border = true;
        output_virt_lines = false;
        output_win_border = ["" "━" "" ""];
        output_win_hide_on_leave = true;
        output_win_max_height = 15;
        output_win_max_width = 80;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        tick_rate = 500;
        use_border_highlights = false;
        limit_output_chars = 10000;
        wrap_output = true;
        virt_text_output = true;
        virt_lines_off_by_1 = true;
      };
    };
    quarto = {
      enable = true;
      lazyLoad.settings.ft = ["quarto" "markdown"];
      settings = {
        lspFeatures = {
          languages = ["python"];
          chunks = "all";
          diagnostics = {
            enabled = true;
            triggers = ["BufWritePost"];
          };
          completion = {
            enabled = true;
          };
        };
        codeRunner = {
          enabled = true;
          default_method = "molten";
        };
      };
    };
    jupytext = {
      enable = true;
      settings = {
        # python = {
        #   extension = "md";
        #   style = "markdown";
        #   force_ft = "markdown";
        # };
        style = "markdown";
        output_extension = "md";
        force_ft = "markdown";
      };
    };
  };
}
