class Vector
    attr_reader :x;
    attr_reader :y;
    def initialize(x , y)
        @x = x;
        @y = y;
    end
    def add!(vector2)
        @x += vector2.x
        @y += vector2.y
    end
    def multiply(scalar)
        return Vector.new(@x * scalar, @y * scalar)
    end
    def normalize
        current_mag = Math.sqrt(@x**2 + @y**2)
        norm_x = @x/current_mag
        norm_y = @y/current_mag
        return Vector.new(norm_x, norm_y)
    end
end
class Force < Vector
    attr_reader :magnitude;
    attr_reader :x;
    attr_reader :y;
    def initialize(x, y, magnitude=1)
        super(x, y)
        @magnitude = magnitude
        redefine_components!
    end
    def redefine_components!
        normalized = self.normalize
        @x = normalized.x * magnitude
        @y = normalized.y * magnitude
    end
    def redefine_magnitude!
        @magnitude = Math.sqrt(@x**2 + @y**2)
    end
    def add_force(force2)
        @x += force2.x
        @y += force2.y
        redefine_magnitude!
    end
end
class Physics
    attr_reader :pos;
    def initialize(pos, vel, mass)
        @pos = pos;
        @vel = vel;
        @mass = mass;
    end
    def move!(t)
        @pos.add!(@vel.multiply(t))
    end
    def apply_force!(force, time)
        xacceleration = force.x / @mass
        yacceleration = force.y / @mass
        accel_vector = Vector.new(xacceleration, yacceleration)
        @vel.add!(accel_vector.multiply(time))
    end
end