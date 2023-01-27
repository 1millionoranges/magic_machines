
class SmallMachine
    attr_reader :offset

end

class BigMachine < Machine
    def initialize(inputs)
        super(inputs)
        @pos = inputs[:pos] || Vector.new(0,0)
        @angle = inputs[:angle] || Angle.new(0)
        @machines = []
        @mass = inputs[:mass] || 1
        @center_of_mass = Vector.new(0,0)
        @moment_of_inertia = 1
    end
    def add_machine(machine)
        p machine.pos
        p @pos

        offset = machine.pos.minus(@pos)
        p " "
        p machine.pos.minus(@pos)
        p @pos.minus(machine.pos)
        p offset
        machine.offset = offset
        machine.angle_offset = machine.angle.minus(@angle.radians)
        machine.parent = self
        @machines << machine
        @center_of_mass = calc_center_of_mass
        @moment_of_inertia = calc_moment_of_inertia
    end
    def calc_mass
        mass = 0
        for machine in @machines do
            mass += machine.mass
        end
        return mass
    end
    def move!(t)
        super(t)
        x_sum = 0
        y_sum = 0
        mass = calc_mass
        for machine in @machines
  #         p machine.offset.rotate(@angle.radians)
    #       p @angle
            true_offset = machine.offset.rotate(@angle.radians)
            machine.pos = @pos.add(true_offset)
            x_sum += machine.mass * true_offset.x
            y_sum += machine.mass * true_offset.y
         #   p machine.pos
            machine.angle = @angle.add(machine.angle_offset.radians)
        end
        @center_of_mass.x = x_sum / mass
        @center_of_mass.y = y_sum / mass
        @moment_of_inertia = calc_moment_of_inertia
    end
    def calc_center_of_mass
        x_sum = 0
        y_sum = 0
        mass = calc_mass
        for machine in @machines do
            x_sum += machine.mass * machine.offset.x
            y_sum += machine.mass * machine.offset.y
        end
        return Vector.new(x_sum / mass, y_sum / mass)
    end
    def calc_moment_of_inertia
        moi = 0
        for machine in @machines do
            l = machine.offset().minus(@center_of_mass).magnitude
            moi += (l**2) * machine.mass
        end
        return moi
    end 
    def apply_dynamic_force!(force, pos, t_inc)
        apply_force!(force, t_inc)
        x_moment = pos.x * force.y
        y_moment = pos.y * force.x
        total_moment = x_moment + y_moment
        angular_accel = total_moment / @moment_of_inertia
        @angular_velocity += angular_accel * t_inc
    end
    def draw_init
        super
        @center_of_mass = Vector.new(0,0)
        @com_shape = Circle.new(x: @center_of_mass.x, y: @center_of_mass.y, radius: 12, color: 'purple')

    end
    
    def draw_tick
        super
        @shape.color = 'green'
        com = @pos.add(@center_of_mass)
        @com_shape.x = com.x
        @com_shape.y = com.y

    end
end


