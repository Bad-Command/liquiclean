---
--Liquiclean
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

liquiclean.adj = {
	{x=0, y=1, z=0},
	{x=0, y=-1, z=0},
	{x=1, y=0, z=0},
	{x=-1, y=0, z=0},
	{x=0, y=0, z=1},
	{x=0, y=0, z=-1},

	{x=1, y=-1, z=0},
	{x=-1, y=-1, z=0},
	{x=0, y=-1, z=1},
	{x=0, y=-1, z=-1},
}

liquiclean.is_target_type = function(nodename, targettypes) 
	if nodename == nil then
		minetest.log('error', 'liquiclean.is_target_type():  nodename is nil')
	end
	for i=1,#targettypes do
		if nodename == targettypes[i] then
			return true
		end
	end
	return false
end

liquiclean.prng = PseudoRandom(42);

liquiclean.lavacat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, liquiclean.lavacat_targets, liquiclean.lava_replacement, liquiclean.lavacat_lifespan, liquiclean.lavacat_poisons)
end	

liquiclean.watercat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, liquiclean.watercat_targets, liquiclean.water_replacement, liquiclean.watercat_lifespan, liquiclean.watercat_poisons)
end	

liquiclean.icecat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, liquiclean.icecat_targets, liquiclean.icenine_replacement, liquiclean.icecat_lifespan, liquiclean.icecat_poisons)
end

liquiclean.fireextinguisher_abm=function(pos, node, active_object_count, active_object_count_wider)
	minetest.sound_play("liquiclean_hiss", {pos = pos, gain = 1.3, max_hear_distance = liquiclean.retardantcat_lifespan*1.5})
	minetest.env:set_node(pos, {name="liquiclean:retardantcat", param1=14, param2=liquiclean.retardantcat_lifespan})
end

liquiclean.retardantcat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, liquiclean.retardantcat_targets, liquiclean.retardant_replacements, liquiclean.retardantcat_lifespan, liquiclean.retardantcat_poisons)
end

liquiclean.retardantcleanercat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, liquiclean.retardantcleanercat_targets, liquiclean.retardantcleanercat_replacements, liquiclean.retardantcleanercat_lifespan, liquiclean.retardantcleanercat_poisons)
end

liquiclean.retardant_abm=function(pos, node, active_object_count, active_object_count_wider)
	flames = minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, {'fire:basic_flame'})
	for i=1,#flames do
			if node.param2 > 0 then
				liquiclean.propagate(flames[i], node.name, node.param2-1)
			else
				liquiclean.propagate(flames[i], 'air', 0)
			end	
	end
end


liquiclean.replace = function(pos, replacements) 
	roll = liquiclean.prng:next() / 32767.0
	cumulativeProb = 0
	for i=1,#replacements do
		repl = replacements[i]
		if ( pos.y >= repl.min_y and pos.y <= repl.max_y ) then
			cumulativeProb = cumulativeProb + repl.probability;
			if ( roll < cumulativeProb ) then
				minetest.env:set_node(pos, {name=repl.node, param1=0, param2=repl.param2})
				return
			end
		end
	end
	minetest.env:set_node(pos, {name='air', param1=0, param2=0})
end

liquiclean.propagate = function(pos, nodename, life) 
	minetest.env:set_node(pos, {name=nodename, param1=14, param2=life-1})
end


liquiclean.run = function(pos, node, targettypes, replacement, lifespan, poisontypes)
	life = node.param2

	if ( life == 0 ) then
		liquiclean.replace(pos, replacement)
		return
	end

	poisoned = false
	if ( poisontypes ~= nil ) then
		poisoned = minetest.env:find_node_near(pos, 1, poisontypes) ~= nil
	end

	ignoreAdjacentNodeFound = false
	propagated = false

	if ( not poisoned ) then
		targets = minetest.env:find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+1, z=pos.z+1}, targettypes)
		for i=1,#targets do
			target = minetest.env:get_node(targets[i])
			if ( target.name ~= 'ignore' ) then
				liquiclean.propagate(targets[i], node.name, life)
				propagated = true;
			else
				ignoreAdjacentNodeFound = true
			end
		end
	end
	if ( ignoreAdjacentNodeFound == false or poisoned ) then
		if ( propagated or life ~= lifespan ) then
			liquiclean.replace(pos,replacement)
		else
			minetest.env:set_node(pos, {name='air', param1=0, param2=0})
		end
	end
end




