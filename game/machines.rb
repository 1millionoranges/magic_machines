require './physics.rb'

class Machine < Physics

    @@machines = []
    attr_reader :size
    attr_accessor :shape
    attr_accessor :offset
    attr_accessor :parent
    attr_accessor :pos
    attr_accessor :angle_offset
    attr_accessor :angle
    def initialize(inputs)
        super(inputs)
        @angle = inputs[:angle]
        @angle = Angle.new(0) if !@angle
        @size = inputs[:size]
        @size = 10 if !@size
        @angular_velocity = inputs[:angular_velocity]
        @angular_velocity = 0 if !@angular_velocity
        @@machines << self
        draw_init
    end
    def self.each
        for m in @@machines do
            yield(m)
        end
    end
    def add_shape(shape)
        @shape = shape
    end
    def tick!(t_inc,keys_pressed)
        if !parent
            self.move!(t_inc)
            @angle.rotate!(@angular_velocity * t_inc)       
        else
        end
        draw_tick
    end

    def draw_init
        p1 = pos.add(@angle.get_vector(size))
        p2 = pos.add(@angle.add(Math::PI * (2.0/3.0)).get_vector(size/2.0))
        p3 = pos.add(@angle.add(Math::PI * (4.0/3.0)).get_vector(size/2.0))
        @shape = 
        Triangle.new(
            x1: p1.x,  y1: p1.y,
            x2: p2.x, y2: p2.y,
            x3: p3.x,   y3: p3.y,
            color: 'white',
            z: 100
          )
    end
    def draw_tick
        p1 = pos.add(@angle.get_vector(size))
        p2 = pos.add(@angle.add(Math::PI * (2.0/3.0)).get_vector(size/2.0))
        p3 = pos.add(@angle.add(Math::PI * (4.0/3.0)).get_vector(size/2.0))
        @shape.x1 = p1.x
        @shape.y1 = p1.y
        @shape.x2 = p2.x
        @shape.y2 = p2.y
        @shape.x3 = p3.x
        @shape.y3 = p3.y
    end
end

class RocketBooster < Machine
    def initialize(inputs)
        super(inputs)
        @max_boost = inputs[:max_boost]
        @max_boost = 1 if !@max_boost
        @boost_mag = inputs[:boost_mag]
        @boost_mag = 0 if !@boost_mag
    end

    def boost!(t)
        
        force_mag = @max_boost * @boost_mag
        force = @angle.get_vector(force_mag)
        if !parent
            self.apply_force!(force, t)
        else
            parent.apply_dynamic_force!(force, @offset, t)
        end
    end
    
    def tick!(t_inc, keys_pressed)
        super(t_inc, keys_pressed)
        boost!(t_inc)
    end
    def draw_init

        super
        @shape.color = "red"

    end
end

class PlayerRocket < RocketBooster
    def initialize(inputs)
        super(inputs)
        @velocity_line = Line.new(x1: @pos.x, y1: @pos.y, x2: @pos.x + @vel.x, y2: @pos.y + @vel.y, width: 2, color: 'red')
        @button = inputs[:button] || 'space'
    end
    def tick!(t_inc, keys_pressed)
        if keys_pressed.include?(@button)
            @shape.color = 'blue'
            @boost_mag = 1
        else
            @shape.color = 'aqua'
            @boost_mag = 0
        end
        update_velocity_line
        super(t_inc, keys_pressed)
    end
    def update_velocity_line
        @velocity_line.x1 = @pos.x
        @velocity_line.y1 = @pos.y
        @velocity_line.x2 = @pos.x + @vel.x * 30
        @velocity_line.y2 = @pos.y + @vel.y * 30
    end
end