---
--Liquiclean 1.00
--Copyright (C) 2013 Bad_Command
--
--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU Lesser General Public
--License along with this library; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
----

liquiclean = {}
--liquiclean.version = 1.00

-- config.lua contains configuration parameters
dofile(minetest.get_modpath("liquiclean").."/config.lua")
-- bones.lua contains the code
dofile(minetest.get_modpath("liquiclean").."/liquiclean.lua")

minetest.register_node("liquiclean:lavacat", {
	description = "Lava Catalyst",
	tile_images ={"lavac.png"},
	paramtype = "light",
	paramtype2 = "none",
	groups = {immortal=1},
	drawtype = "glasslike",
	pointable = false,
	diggable = false,
	liquids_pointable = true,
	damage_per_second = 50,
	after_place_node = function(pos, placer)
		minetest.env:set_node(pos, {name="liquiclean:lavacat", param1=14, param2=liquiclean.lavacat_lifespan})
	end
})

minetest.register_node("liquiclean:watercat", {
	description = "Water Catalyst",
	tile_images ={"waterc.png"},
	paramtype = "light",
	paramtype2 = "none",
	groups = {immortal=1},
	drawtype = "glasslike",
	pointable = false,
	diggable = false,
	liquids_pointable = true,
	damage_per_second = 50,
	after_place_node = function(pos, placer)
		minetest.env:set_node(pos, {name="liquiclean:watercat", param1=14, param2=liquiclean.watercat_lifespan})
	end
})

minetest.register_node("liquiclean:icecat", {
	description = "Ice Catalyst",
	tile_images ={"icec.png"},
	paramtype = "light",
	paramtype2 = "none",
	groups = {immortal=1},
	drawtype = "glasslike",
	pointable = false,
	diggable = false,
	damage_per_second = 50,
	after_place_node = function(pos, placer)
		minetest.env:set_node(pos, {name="liquiclean:icecat", param1=14, param2=liquiclean.icecat_lifespan})
	end
})

minetest.register_node("liquiclean:icenine", {
	description = "Ice Nine",
	tile_images ={"icenine.png"},
	drawtype = "glasslike",
	paramtype = "light",
	paramtype2 = "none",
	groups = {crumbly=2},
})

minetest.register_craft({
	output = 'liquiclean:lavacat',
	recipe = {
                {'bucket:bucket_water', 'bucket:bucket_lava', 'default:mese'},
                {'', '', ''},
                {'', '', ''},
        }
})

minetest.register_craft({
	output = 'liquiclean:icecat',
	recipe = {
                {'liquiclean:icenine', 'liquiclean:icenine', 'liquiclean:icenine'},
                {'default:torch', 'default:torch', 'default:torch'},
                {'', '', ''},
        }
})

minetest.register_craft({
	output = 'liquiclean:watercat',
	recipe = {
                {'default:mese', 'bucket:bucket_water', 'default:mese'},
                {'', '', ''},
                {'', '', ''},
        }
})

minetest.register_abm(
	{nodenames = {"liquiclean:lavacat"},
	interval = 0.25,
	chance = 5,
	action = liquiclean.lavacat_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:watercat"},
	interval = 0.25,
	chance = 5,
	action = liquiclean.watercat_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:icecat"},
	interval = 0.25,
	chance = 5,
	action = liquiclean.icecat_abm
})
