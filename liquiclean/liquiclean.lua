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

liquiclean.adj = {{x=1, y=0, z=0},
			{x=-1, y=0, z=0},
			{x=0, y=1, z=0},
			{x=0, y=-1, z=0},
			{x=0, y=0, z=1},
			{x=0, y=0, z=-1}}

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
	liquiclean.run(pos, node, {'default:lava_source', 'default:lava_flowing'}, liquiclean.lava_replacement)
end	

liquiclean.watercat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, {'default:water_source', 'default:water_flowing'}, liquiclean.water_replacement)
end	

liquiclean.icecat_abm=function(pos, node, active_object_count, active_object_count_wider)
	liquiclean.run(pos, node, {'liquiclean:icenine'}, liquiclean.icenine_replacement)
end	

liquiclean.replace = function(pos, replacements) 
	roll = liquiclean.prng:next() / 32767.0
	cumulativeProb = 0
	for i=1,#replacements do
		repl = replacements[i]
		if ( pos.y >= repl.min_y and pos.y <= repl.max_y ) then
			cumulativeProb = cumulativeProb + repl.probability;
			if ( roll < cumulativeProb ) then
				minetest.env:set_node(pos, {name=repl.node, param1=0, param2=0})
				return
			end
		end
	end
	minetest.env:set_node(pos, {name='air', param1=0, param2=0})
end
liquiclean.propagate = function(pos, nodename, life) 
	minetest.env:set_node(pos, {name=nodename, param1=14, param2=life-1})
end


liquiclean.run = function(pos, node, targettypes, replacement)
	life = node.param2


	if ( life == 0 ) then
		liquiclean.replace(pos, replacement)
		return
	end

	ignoreAdjacentNodeFound = false
	for i=1,#liquiclean.adj do
		nextpos = {x=pos.x + liquiclean.adj[i].x,
				y=pos.y + liquiclean.adj[i].y,
				z=pos.z + liquiclean.adj[i].z}
		target = minetest.env:get_node(nextpos)
		if ( liquiclean.is_target_type(target.name, targettypes) ) then
			liquiclean.propagate(nextpos, node.name, life)
		end
		if ( target.name == 'ignore' ) then
			ignoreAdjacentNodeFound = true
		end
	end

	if ( ignoreAdjacentNodeFound == false ) then
		liquiclean.replace(pos,replacement)
	end
end




