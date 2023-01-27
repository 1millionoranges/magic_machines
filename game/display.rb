require './physics.rb'
require './machines.rb'
require 'ruby2d'
require './events.rb'
require './big_machine.rb'

set title: "Hello Triangle"
keys_pressed = []
t_inc = 0.2

RocketBooster.new(pos: Vector.new(100,100))
a = PlayerRocket.new(pos: Vector.new(500,100), angle: Angle.new(Math::PI), button: 'up')
b = PlayerRocket.new(pos: Vector.new(450,80), angle: Angle.new(Math::PI/2), button: 'd')
c = PlayerRocket.new(pos: Vector.new(450,120), angle: Angle.new(Math::PI * (3.0/2)), button: 'a')
b2 = PlayerRocket.new(pos: Vector.new(400,80), angle: Angle.new(Math::PI/2), button: 'e')
c2 = PlayerRocket.new(pos: Vector.new(400,120), angle: Angle.new(Math::PI * (3.0/2)), button: 'q')
d = BigMachine.new(pos: Vector.new(500,100), angle: Angle.new(0))
d.add_machine(a)
d.add_machine(b)
d.add_machine(c)
d.add_machine(b2)
d.add_machine(c2)

on :key_down do |event|    
    keys_pressed << event.key
    if event.key == "escape"
        close
    end
end

on :key_up do |event|
    keys_pressed.delete(event.key)
end


update do
    Machine.each do |machine|
        machine.tick!(t_inc, keys_pressed)
    end    
end

show
