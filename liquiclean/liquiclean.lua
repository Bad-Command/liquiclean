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




