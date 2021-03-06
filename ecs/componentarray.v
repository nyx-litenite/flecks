module ecs

pub interface IComponentContainer {
	entity_destroyed(entity Entity)
//	destroy_entity()
}

pub struct ComponentArray<T> {
	mut:
	field []T = []T{len:int(max_entities), cap:int(max_entities)}
	entity_index map[Entity]i16
	index_entity map[i16]Entity
	size i16
}

pub fn (mut c ComponentArray<T>) insert(entity Entity, component T) {
	assert entity !in c.entity_index

	new_ndx := c.size
	c.entity_index[entity] = new_ndx
	c.index_entity[new_ndx] = entity

	c.field[new_ndx] = entity
	c.size++
}

pub fn (mut c ComponentArray<T>) remove(entity Entity) {
	assert entity in c.entity_index

	ndx := c.entity_index[entity]
	last_ndx := c.size - 1

	c.field[ndx] = c.field[last_ndx]
	last_entity := c.index_entity[last_ndx]

	c.entity_index[last_entity] = ndx
	c.index_entity[ndx] = last_entity

	c.entity_index.delete(entity)
	c.index_entity.delete(last_ndx)

	c.size--
}

pub fn (c ComponentArray<T>) get(entity Entity) ?T {
	if entity !in c.entity_index {
		return none
	}

	return c.field[c.entity_index[entity]]
}

pub fn (mut c ComponentArray<T>) entity_destroyed(entity Entity) {
	if entity in c.entity_index {
		c.remove(entity)
	}
}

// pub fn (mut c ComponentArray<T>) destroy_entity(entity Entity) {
// 	if entity in c.entity_index {
// 		c.remove(entity)
// 	}
// } 