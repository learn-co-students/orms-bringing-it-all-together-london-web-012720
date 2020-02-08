class Dog

    attr_accessor :name, :breed, :id

    def initialize(args)
        @name = args[:name]
        @breed = args[:breed]
        if args[:id]
        @id = args[:id]
        else
        @id = nil
        end
    end

    def self.create_table
        sql = <<-SQL
        CREATE TABLE dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        );
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
        DROP TABLE dogs
        SQL

        DB[:conn].execute(sql)
    end

    def save
        if @id != nil
            self.update
            self
        else
            sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
            SQL

            DB[:conn].execute(sql, self.name, self.breed)
            @id = DB[:conn].execute("SELECT MAX(ID) AS LastID FROM dogs")[0][0]
            self
        end
    end

    def self.create(args)
        doge = self.new(args)
        doge.save
    end

    def self.new_from_db(row)
        doge = self.new({id: row[0], name: row[1], breed: row[2]})   
    end

    def self.find_by_id(n)
        sql = <<-SQL
        SELECT * FROM dogs
        WHERE id = ?
        SQL

        info = DB[:conn].execute(sql, n)[0]
        self.new({id: info[0], name: info[1], breed: info[2]})
    end

    def self.find_by_name(n)
        sql = <<-SQL
        SELECT * FROM dogs
        WHERE name = ?
        SQL

        info = DB[:conn].execute(sql, n)[0]
        self.new({id: info[0], name: info[1], breed: info[2]})
    end

    def self.find_or_create_by(name:, breed:)
        doge = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !doge.empty?
      doge_data = doge[0]
      doge = self.new(id: doge_data[0], name: doge_data[1], breed: doge_data[2])
    else
      doge = self.create(name: name, breed: breed)
    end
    doge
    end

    def update
        sql = <<-SQL
        UPDATE dogs SET name = ?, breed = ?
        WHERE id = ?
        SQL
        DB[:conn].execute(sql, self.name, self.breed, self.id)
    end


end