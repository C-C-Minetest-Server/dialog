--[[
Copyright (C) 2022 Wuzzy
Copyright (C) 2023 1F616EMO

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

For the full license text, refer to LICENSE and gpl-3.0.txt.
]]

local MP = minetest.get_modpath("dialog")

dofile(MP .. "/api.lua")
if minetest.is_singleplayer() or minetest.settings:get_bool("dialog_register_example", false) then
	dofile(MP .. "/example.lua")
end

