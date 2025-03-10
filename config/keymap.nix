{
  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = "<cmd>lua require('smart-splits').move_cursor_left()<CR>";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<cmd>lua require('smart-splits').move_cursor_down()<CR>";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>lua require('smart-splits').move_cursor_up()<CR>";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<cmd>lua require('smart-splits').move_cursor_right()<CR>";
    }

    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>lua require('smart-splits').move_cursor_left()<CR>";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>lua require('smart-splits').move_cursor_down()<CR>";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>lua require('smart-splits').move_cursor_up()<CR>";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>lua require('smart-splits').move_cursor_right()<CR>";
    }

    {
      mode = "n";
      key = "<A-h>";
      action = "<cmd>lua require('smart-splits').resize_left()<CR>";
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>lua require('smart-splits').resize_down()<CR>";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>lua require('smart-splits').resize_up()<CR>";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = "<cmd>lua require('smart-splits').resize_right()<CR>";
    }

    {
      mode = "n";
      key = "<A-Left>";
      action = "<cmd>lua require('smart-splits').resize_left()<CR>";
    }
    {
      mode = "n";
      key = "<A-Down>";
      action = "<cmd>lua require('smart-splits').resize_down()<CR>";
    }
    {
      mode = "n";
      key = "<A-Up>";
      action = "<cmd>lua require('smart-splits').resize_up()<CR>";
    }
    {
      mode = "n";
      key = "<A-Right>";
      action = "<cmd>lua require('smart-splits').resize_right()<CR>";
    }

    {
      mode = "n";
      key = "<C-S-h>";
      action = "<cmd>lua require('smart-splits').swap_buf_left()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-j>";
      action = "<cmd>lua require('smart-splits').swap_buf_down()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-k>";
      action = "<cmd>lua require('smart-splits').swap_buf_up()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-l>";
      action = "<cmd>lua require('smart-splits').swap_buf_right()<CR>";
    }

    {
      mode = "n";
      key = "<C-S-Left>";
      action = "<cmd>lua require('smart-splits').swap_buf_left()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-Down>";
      action = "<cmd>lua require('smart-splits').swap_buf_down()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-Up>";
      action = "<cmd>lua require('smart-splits').swap_buf_up()<CR>";
    }
    {
      mode = "n";
      key = "<C-S-Right>";
      action = "<cmd>lua require('smart-splits').swap_buf_right()<CR>";
    }

    {
      mode = "n";
      key = "<localleader>e";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    }
    {
      mode = "n";
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
    }
    {
      mode = "n";
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    }
    {
      mode = "n";
      key = "K";
      action = "<cmd>lua vim.lsp.buf.hover()<CR>";
    }
    {
      mode = "n";
      key = "<localleader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
    }
    {
      mode = "v";
      key = "<Leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "s";
      action = "<cmd>lua require('flash').jump()<CR>";
    }
    {
      mode = "n";
      key = "S";
      action = "<cmd>lua require('flash').treesitter()<CR>";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>lua require('mini.files').open()<CR>";
    }
    {
      mode = "n";
      key = "<leader>hh";
      action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>";
      options = {
        silent = true;
        desc = "toggle harpoon quick menu";
      };
    }
    {
      mode = "n";
      key = "<leader>hm";
      action = "<cmd>lua require('harpoon.mark').add_file()<CR>";
      options = {
        silent = true;
        desc = "add file to harpoon";
      };
    }
  ];
}
