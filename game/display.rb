require './physics.rb'
require './machines.rb'
require 'ruby2d'
require './events.rb'

set title: "Hello Triangle"
keys_pressed = []
t_inc = 0.1

object = RocketBooster.new(Vector.new(100,100), Vector.new(1,1), 1, Angle.new(0), 0.1, 20, 1)
object = Machine.new(Vector.new(200,100), Vector.new(1,1), 1, Angle.new(0), 0.001, 10)
force = Force.new( 1, -1 )

on :key_down do |event|
    
    keys_pressed << event.key
    if event.key == "escape"
        close
    end
end
on :key_up do |event|
    keys_pressed.delete(event.key)
end

Machine.each do |machine|

    
end
update do
    Machine.each do |machine|
        machine.tick!(t_inc, keys_pressed)
    end
    
    
 #   sleep(t_inc)
end

show
