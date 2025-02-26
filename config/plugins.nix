# Misc Plugins
{
  plugins = {
  	lz-n.enable = true;
	hydra.enable = true;
    obsidian = {
      enable = true;
      lazyLoad.settings.ft = "markdown";
      settings = {
        workspaces = [
          {
            name = "Education";
            path = "~/vaults/Education";
          }
        ];

        attachments = {
          img_folder = "Media/Images";
        };

        templates = {
          folder = "Templates";
          date_format = "%Y-%m-%d-%a";
          time_format = "%H:%M";
        };

        daily_notes = {
          folder = "Daily";
          template = "Daily-Template.md";
        };

        picker = {
          name = "fzf-lua";
          note_mappings = {
            new = "<C-x>";
            insert_link = "<C-l>";
          };
          tag_mappings = {
            tag_note = "<C-x>";
            insert_tag = "<C-l>";
          };
        };

        note_id_func.__raw = ''
		function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.time()) .. "-" .. suffix
			end
        '';
      };
    };
  };
}
