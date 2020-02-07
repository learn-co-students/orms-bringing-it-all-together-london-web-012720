def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)

    
    if !dog.empty?
        dog_data = dog[0]
        dog = Dog.new(name: dog_data[1], breed: dog_data[2], id: dog_data[0])
    else
        dog = self.create(name: name, breed: breed)
    end
    dog
end