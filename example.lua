--[[
Copyright (C) 2022 Wuzzy
Copyright (C) 2023 1F616EMO

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

For the full license text, refer to LICENSE and gpl-3.0.txt.
]]

local S = minetest.get_translator("dialog")

local SYS = "dialog:example_system"
local PLA = "dialog:example_player"
local HLP = "dialog:example_helper"

dialog.register_speaker(PLA, {
	name = S("Player"),
	portrait = "glitch_dialog_portrait_player.png",
})

dialog.register_speaker(HLP, {
	name = S("System Helper"),
	portrait = "glitch_dialog_portrait_helper.png",
})

dialog.register_speaker(SYS, {
	name = "S.Y.S.T.E.M",
	portrait = "glitch_dialog_portrait_system.png",
})

dialog.register_dialogtree("dialog:example", {
	speeches = {
		start = {
			text = S("dialog  Copyright (C) 2022-2023 1F616EMO and Wuzzy \nThis program comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it under certain conditions.\n" .. dialog.fork),
			speaker = SYS,
			options = {{ action = "speech", next_speech = "step2" }},
		},
		step2 = {
			text = S("The following option is generated dynamically."),
			speaker = SYS,
			options = function()
				return {{ action = "speech", next_speech = "step3" }}
			end,
		},
		step3 = {
			text = S("Here are three options. Which one do you want to choose?"),
			speaker = HLP,
			options = {
				{ action = "speech", next_speech = "step4_opt1", text = S("I wanna speak.") },
				{ action = "speech", next_speech = "step4_opt2", text = S("Tell me some jokes.") },
				{ action = "speech", dialogtree_id = "dialog:example_2", text = S("Summon another dialog tree.") },
				{ action = "quit", text = S("None of above. Bye.") },
			}
		},
		step4_opt1 = {
			text = S("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
			speaker = PLA,
			options = {{ action = "speech", next_speech = "step3" }},
		},
		step4_opt2 = {
			text = S("Why did the chicken cross the road? To get to the other side. "),
			speaker = HLP,
			options = {{ action = "speech", next_speech = "step4_opt2_2" }},
		},
		step4_opt2_2 = {
			text = S("BRUH."),
			speaker = PLA,
			options = {{ action = "speech", next_speech = "step3" }},
		},
	}
})

dialog.register_dialogtree("dialog:example_2", {
	speeches = {
		{
			text = S("Dialog tree 2 summoned."),
			speaker = SYS,
		},
		{
			text = S("Thanks!"),
			speaker = PLA,
		},
		{
			text = S("What do you want to do next?"),
			speaker = HLP,
			options = {
				{ action = "speech", dialogtree_id = "dialog:example", next_speech = "step3", text = S("Back to the menu.") },
				{ action = "quit", text = S("Leave.") },
			}
		}
	}
})

minetest.register_chatcommand("dialog_example", {
	description = S("Open a example dialog."),
	func = function(name,param)
		glitch_dialog.show_dialogtree(minetest.get_player_by_name(name),"dialog:example")
	end
})

