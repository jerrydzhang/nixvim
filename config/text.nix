{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight = {
          enable = true;
          disable = [
            # "latex"
          ];
        };
      };
    };
    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
        };
        # selection_modes = {
        # 	"@function.outer" = "v";
        # 	"@function.inner" = "v";
        # };
      };
      swap = {enable = true;};
      move = {enable = true;};
    };
    treesitter-context = {
      enable = true;
      settings = {
        multiline_threshold = 2;
      };
    };
    cmp = {
      enable = true;
      luaConfig.pre = "local luasnip = require('luasnip')";
      settings = {
        autoEnableSources = true;
        performance = {debounce = 150;};
        sources = [
          {name = "path";}
          {name = "buffer";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
        ];
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping = {
          "<Up>" = "cmp.mapping.select_prev_item()";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          "<C-d>" = "cmp.mapping.scroll_docs(4)";
          "<C-y>" = "cmp.mapping.confirm({select = true})";
          "<CR>" = "cmp.mapping.confirm({select = false})";
          "<Tab>" = ''
            cmp.mapping(
              function(fallback)
                if luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end,
              { "i", "s" }
            )
          '';
          "<S-Tab>" = ''
            cmp.mapping(
              function(fallback)
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end,
              { "i", "s" }
            )
          '';
          "<C-e>" = ''
            cmp.mapping(
              function(fallback)
                if luasnip.choice_active() then
                  luasnip.change_choice(1)
                else
                  fallback()
                end
              end,
              { "i", "s" }
            )
          '';
          "<C-f>" = ''
            cmp.mapping(
              function(fallback)
                local col = vim.fn.col('.') - 1

                if cmp.visible() then
                  cmp.select_next_item(select_opts)
                elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                  fallback()
                else
                  cmp.complete()
                end
              end,
              { "i", "s" }
            )
          '';
          "<C-b>" = ''
            cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item(select_opts)
                else
                  fallback()
                end
              end,
              { "i", "s" }
            )
          '';
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
            zindex = 1001;
            scrolloff = 0;
            colOffset = 0;
            sidePadding = 1;
            scrollbar = true;
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
            zindex = 1001;
            maxHeight = 20;
          };
        };
      };
    };
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.auto_trigger = true;
      };
    };
    nui.enable = true;
    dressing.enable = true;
    avante = {
      enable = true;
      settings = {
        provider = "copilot";
        auto_suggestions_provider = null;
      };
    };
    luasnip = {
      enable = true;
      fromLua = [
        {
          # paths = ./snippets;
          paths = "~/modules/nixvim/config/snippets";
        }
      ];
      settings = {
        enable_autosnippets = true;
        cut_selection_keys = "<tab>";
      };
    };
    none-ls = {
      enable = true;
      sources.formatting = {
        alejandra.enable = true;
      };
      sources.diagnostics = {
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = "fallback";
          timeout_ms = 500;
        };
        notify_on_error = true;

        formatters_by_ft = {
          nix = ["alejandra"];
        };
      };
    };

    lsp = {
      enable = true;
      inlayHints = true;
      keymaps = {
        diagnostic = {
          "<localleader>e" = "open_float";
          "[" = "goto_prev";
          "]" = "goto_next";
          "<leader>do" = "setloclist";
        };
        lspBuf = {
          "K" = "hover";
          "<localleader>gD" = "declaration";
          "<localleader>gd" = "definition";
          "<localleader>gr" = "references";
          "<localleader>gI" = "implementation";
          "<localleader>gy" = "type_definition";
          "<localleader>ca" = "code_action";
          "<localleader>cr" = "rename";
          "<localleader>wl" = "list_workspace_folders";
          "<localleader>wr" = "remove_workspace_folder";
          "<localleader>wa" = "add_workspace_folder";
        };
      };
      preConfig = ''
        vim.diagnostic.config({
          virtual_text = true,
          severity_sort = true,
          float = {
            border = 'rounded',
            source = 'always',
          },
        })

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
          vim.lsp.handlers.hover,
          {border = 'rounded'}
        )

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          {border = 'rounded'}
        )
      '';
      postConfig = ''
        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end
      '';
      servers = {
        nil_ls.enable = true;
      };
    };
  };
}
