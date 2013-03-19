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

liquiclean.lavacat_lifespan = 25
liquiclean.lavacat_targets = {'default:lava_source', 'default:lava_flowing', 'ignore'}
liquiclean.lavacat_poisons = nil
liquiclean.lava_replacement = {
	{node="default:stone", probability=0.007, min_y=-50, max_y=31000},
	{node="air", probability=1, min_y=-50, max_y=31000},

	{node="default:nyancat", probability=0.00004, min_y=-3100, max_y=-40},
	{node="default:nyancat_rainbow", probability=0.00008, min_y=-3100, max_y=-40},
	{node="default:stone_with_iron", probability=0.02, min_y=-31000, max_y=-49},
	{node="default:stone_with_coal", probability=0.02, min_y=-31000, max_y=-49},
	{node="air", probability=0.02, min_y=-31000, max_y=-49},
	{node="default:stone", probability=1, min_y=-31000, max_y=-49}
}

liquiclean.watercat_lifespan = 25
liquiclean.watercat_targets = {'default:water_source', 'default:water_flowing', 'ignore'}
liquiclean.watercat_poisons = {'liquiclean:icecat', 'default:lava_source', 'default:lava_flowing'}
liquiclean.water_replacement = {
	{node="liquiclean:icenine", probability=1, min_y=-31000, max_y=1},

	{node="air", probability=1, min_y=2, max_y=31000}
}


liquiclean.icecat_lifespan = 30
liquiclean.icecat_targets = {'liquiclean:icenine', 'liquiclean.watercat', 'ignore'}
liquiclean.icecat_poisons = {'liquiclean:watercat'}
liquiclean.icenine_replacement = {
	{node="default:water_source", probability=1, min_y=-31000, max_y=31000}
}






