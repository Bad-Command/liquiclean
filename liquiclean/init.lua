---
--Liquiclean 1.11
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
liquiclean.version = 1.11

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
	damage_per_second = 1,
	after_place_node = function(pos, placer)
		minetest.env:set_node(pos, {name="liquiclean:icecat", param1=14, param2=liquiclean.icecat_lifespan})
	end
})

minetest.register_node("liquiclean:fireextinguisher", {
	description = "Automatic Fire Extinguisher",
	tile_images ={"fireextinguisher.png"},
	paramtype = "light",
	paramtype2 = "none",
	drawtype = "plantlike",
	pointable = true,
	diggable = true,
	damage_per_second = 0,
})


minetest.register_node("liquiclean:fireretardant", {
	description = "Fire Retardant Fog",
	tile_images ={"retardant.png"},
	paramtype = "light",
	paramtype2 = "none",
	drawtype = "plantlike",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {dig_immediate=3, oddly_breakable_by_hand=3},
	pointable = true,
	diggable = true,
	damage_per_second = 0,
})

minetest.register_node("liquiclean:retardantcat", {
	description = "Fire Retardant Catalyst",
	tile_images ={"retardantc.png"},
	paramtype = "light",
	paramtype2 = "none",
	groups = {immortal=1},
	walkable = false,
	drawtype = "glasslike",
	pointable = false,
	diggable = false,
	damage_per_second = 1,
})

minetest.register_node("liquiclean:retardantcleanercat", {
	description = "Fire Retardant Cleaner Catalyst",
	tile_images ={"retardantcc.png"},
	paramtype = "light",
	paramtype2 = "none",
	walkable = false,
	groups = {immortal=1},
	drawtype = "glasslike",
	pointable = false,
	diggable = false,
	damage_per_second = 1,
	after_place_node = function(pos, node, active_object_count, active_object_count_wider) 
		minetest.env:set_node(pos, {name="liquiclean:retardantcleanercat", param1=14, param2=liquiclean.retardantcleanercat_lifespan})	
	end
})

minetest.register_node("liquiclean:icenine", {
	description = "Clean Ice",
	tile_images ={"icenine.png"},
	drawtype = "glasslike",
	paramtype = "light",
	paramtype2 = "none",
	groups = {crumbly=2},
})

minetest.register_craft({
	output = 'liquiclean:fireextinguisher',
	recipe = {
                {'bucket:bucket_water', 'default:torch', 'default:mese'},
                {'', '', ''},
                {'', '', ''},
        }
})

minetest.register_craft({
	output = 'liquiclean:retardantcleanercat',
	recipe = {
                {'liquiclean:fireretardant', 'liquiclean:fireretardant', 'liquiclean:fireretardant'},
                {'default:torch', 'default:torch', 'default:torch'},
                {'', '', ''},
        }
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

minetest.register_abm({
	nodenames = {"liquiclean:fireextinguisher"},
	neighbors = {"default:lava_source", "default:lava_flowing", "fire:basic_flame", "default:torch"},
	interval = 0.1,
	chance = 1,
	action = liquiclean.fireextinguisher_abm
})

minetest.register_abm({
	nodenames = {"liquiclean:fireretardant"},
	neighbors = {"fire:basic_flame"},
	interval = 0.1,
	chance = 1,
	action = liquiclean.retardant_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:retardantcat"},
	interval = 0.05,
	chance = 2,
	action = liquiclean.retardantcat_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:retardantcleanercat"},
	interval = 0.3,
	chance = 2,
	action = liquiclean.retardantcleanercat_abm
})


minetest.register_abm(
	{nodenames = {"liquiclean:lavacat"},
	interval = 0.15,
	chance = 2,
	action = liquiclean.lavacat_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:watercat"},
	interval = 0.15,
	chance = 2,
	action = liquiclean.watercat_abm
})

minetest.register_abm(
	{nodenames = {"liquiclean:icecat"},
	interval = 0.3,
	chance = 2,
	action = liquiclean.icecat_abm
})
