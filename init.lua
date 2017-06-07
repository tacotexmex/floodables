floodables = {}

function floodables.register_soil(def)
for key,value in pairs(minetest.registered_nodes) do
	if minetest.get_item_group(value.name, def.name) ~= 0 then

-- overrides all soil nodes to add the falling_group
		minetest.override_item(value.name,{
			groups = {soil = 1, falling_node = 1},
		})

		minetest.register_abm({
			label = "soil erosion",
			nodenames = value.name,
			neighbors = "air",
			interval = def.interval,
			chance = def.chance,

-- This function check if there space under the soil, and if true, set "air" at
-- the old position and put the old node 1 Y lower
			action = function(pos)
				if math.random(def.erode_chance) == 1 then
				local pmin = {x = pos.x - 1, y = pos.y - 1, z = pos.z - 1}
				local pmax = {x = pos.x + 1, y = pos.y - 1, z = pos.z + 1}
				local area = minetest.find_nodes_in_area(pmin,pmax,"air")
					if table.getn(area) > 0 then
						minetest.set_node(pos,{name = "air"})
          local pos = area[math.random(table.getn(area))]
						minetest.set_node(pos,{name = value.name})
						minetest.check_single_for_falling(pos) -- make all floating dirt fall
					end
				end
			end,
		})
	end
end
end

function floodables.register_crops(def)
local size = 1
	while minetest.registered_nodes[def.name.."_"..size] ~= nil do
		minetest.override_item(def.name.."_"..size, {
			floodable = true,

			on_flood = function(pos)
				if math.random(def.func_chance) == 1 then
					minetest.sound_play({ name = def.sound, gain = def.gain }, { pos = pos, max_hear_distance = 16 })
					if math.random(def.drop_chance) == 1 then
					local node  = minetest.get_node(pos)
					local drops = minetest.get_node_drops(node.name)
					local index = math.random(table.getn(drops))
						minetest.set_node(pos, {name="air"})
						minetest.add_item(pos, drops[index])
					else
						minetest.set_node(pos, {name="air"})
					end
				end
			end,
		})
	size = size + 1
	end
end

function floodables.register_groups(def)
for key,value in pairs(minetest.registered_nodes) do
	if minetest.get_item_group(value.name, def.name) ~= 0 then
		minetest.override_item(value.name, {
			floodable = true,

			on_flood = function(pos)
				if math.random(def.func_chance) == 1 then
					minetest.sound_play({ name = def.sound, gain = def.gain }, { pos = pos, max_hear_distance = 16 })
					if math.random(def.drop_chance) == 1 then
					local drops = minetest.get_node_drops(value.name)
					local index = math.random(table.getn(drops))
						minetest.set_node(pos, {name="air"})
						minetest.add_item(pos, drops[index])
					else
						minetest.set_node(pos, {name="air"})
					end
				end
			end,
		})
	end
end
end

--------------------------------------------------------------------------------
-- Groups registration
--------------------------------------------------------------------------------
floodables.register_soil({
	name = "soil",
	chance = 4,
	interval = 2,
	erode_chance = 8,
})


--------------------------------------------------------------------------------
-- Groups registration
--------------------------------------------------------------------------------
floodables.register_groups({
	name = "flora",
	func_chance = 2,
	drop_chance = 4,
	sound = "floodables_grass",
	gain  = 0.2,
})
floodables.register_groups({
	name = "flower",
	func_chance = 2,
	drop_chance = 4,
	sound = "floodables_grass",
	gain  = 0.2,
})
floodables.register_groups({
	name = "torch",
	func_chance = 1,
	drop_chance = 1,
	sound = "floodables_torch",
	gain  = 0.8,
})

--------------------------------------------------------------------------------
-- Crops registration
--------------------------------------------------------------------------------
floodables.register_crops({
	name = "farming:wheat",
	func_chance = 1,
	drop_chance = 1,
	sound = "floodables_grass",
	gain  = 0.2,
})
floodables.register_crops({
	name = "farming:cotton",
	func_chance = 1,
	drop_chance = 1,
	sound = "floodables_grass",
	gain  = 0.2,
})

-- Although the grass is inside the flora group, i prefered to add is in a crop
-- function, just to be same with the dry grass, which has no group
floodables.register_crops({
	name = "adefault:grass",
	func_chance = 1,
	drop_chance = 1,
	sound = "floodables_grass",
	gain  = 0.2,
})
floodables.register_crops({
	name = "default:dry_grass",
	func_chance = 1,
	drop_chance = 1,
	sound = "floodables_grass",
	gain  = 0.2,
})
