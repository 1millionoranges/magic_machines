class Vector
    attr_accessor :x;
    attr_accessor :y;
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
    def add(vector2)
        return Vector.new(@x + vector2.x, @y + vector2.y)
    end
    def minus(vector2)
        return Vector.new(@x - vector2.x, @y - vector2.y)
    end
    def magnitude
        return Math.sqrt(x**2 + y**2)
    end
    def to_vector_2
        angle = Angle.from_vector(self)
        return Vector_2.new(angle, magnitude)
    end
    def rotate(rads)
        
        vec2 = self.to_vector_2
        vec2.angle.radians += rads
   #     p "vec2"
    #    p vec2
    #    p "vec"
     #   p vec2.to_vector
        return vec2.to_vector
    end
end
class Vector_2
    attr_accessor :angle
    attr_accessor :magnitude
    def initialize(angle, magnitude)
        @angle = angle
        @magnitude = magnitude
    end
    def to_vector
        Vector.new(@magnitude * Math.cos(@angle.radians), @magnitude * Math.sin(@angle.radians))
    end
end
class Angle
    attr_accessor :radians
    def initialize(radians)
        @radians = radians
    end
    def get_vector(magnitude=1)
        x_norm = Math.cos(@radians)
        y_norm = Math.sin(@radians)
        Vector.new(x_norm * magnitude, y_norm * magnitude)
    end
    def rotate!(rads)
        @radians += rads
    end
    def add_angle(angle)
        return Angle.new(@radians + angle.radians)
    end
    def add(rads)
        return Angle.new(@radians + rads)
    end
    def minus(rads)
        return Angle.new(@radians - rads)
    end
    def self.from_vector(vector)
   #     p vector
        if vector.x == 0
            ang = Angle.new(Math::PI/2) 
        else
   #         p "vector.x, y"
    #        p vector.x
     #       p vector.y

            ang = Angle.new(Math.atan(  (vector.y.to_f) / (vector.x)  ) )
        end
    #    p "ang"
    #    p ang
    #    if vector.y < 0
            ang.radians += Math::PI
     #   end
      #  p ang
        return ang
    end
end
class Force < Vector
    attr_reader :magnitude;
    attr_reader :x;
    attr_reader :y;
    def initialize(x, y, magnitude=nil)
        super(x, y)
        if magnitude
            @magnitude = magnitude
            redefine_components!
        end
    end
    def redefine_components!
        normalized = self.normalize
        @x = normalized.x * magnitude
        @y = normalized.y * magnitude
    end
    def redefine_magnitude!
        @magnitude = magnitude
    end
    def add_force(force2)
        @x += force2.x
        @y += force2.y
        redefine_magnitude!
    end
end
class Physics
    attr_reader :pos;
    attr_reader :mass;
    def initialize(inputs)
        @pos = inputs[:pos];
        @pos = Vector.new(0,0) if !@pos
        @vel = inputs[:vel];
        @vel = Vector.new(0,0) if !@vel
        @mass = inputs[:mass];
        @mass = 1 if !mass
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