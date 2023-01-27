require './physics.rb'

require 'ruby2d'
set title: "Hello Triangle"
t_inc = 0.1
object = Physics.new(Vector.new(100,100), Vector.new(1,1), 1)
force = Force.new( 1, -1 )
c = Circle.new(
        x: object.pos.x, y: object.pos.y,
        radius: 150,
        color: 'fuchsia',
      )
update do
    
    object.apply_force!(force, t_inc)
    object.move!(t_inc)
    p object.pos.x;
    c.x = object.pos.x;
    c.y = object.pos.y;
    
 #   sleep(t_inc)
end

show
