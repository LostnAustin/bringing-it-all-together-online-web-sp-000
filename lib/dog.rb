require 'pry'
class Dog
  attr_accessor  :id, :name, :breed


  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end


  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs
    SQL
    DB[:conn].execute(sql)
  end

  def save
#     if self.id
#   sql = <<-SQL
#   UPDATE dogs SET name = ?, breed = ?
#   WHERE id = ?
#   SQL
#   DB[:conn].execute(sql, self.name, self.breed, self.id)
# else
  sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES (?,?)
    SQL
   results = DB[:conn].execute(sql, name, breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]

    dog = Dog.new(id: id, name: name, breed: breed)
    dog
# end
# binding.pry
  end

  def self.create(hash)
    dog = Dog.new(hash)
    dog.save
    dog
  end

  def self.new_from_db(array)
    id = array[0]
    name = array[1]
    breed = array[2]
    dog = self.new(id: id, name: name, breed: breed)
    dog
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT * FROM dogs WHERE dogs.id = ? LIMIT 1
    SQL
      results = DB[:conn].execute(sql, id).flatten
      dog = Dog.new(id: results[0], name: results[1], breed: results[2])
      dog
  end

  def update
    sql = <<-SQL
      UPDATE dogs SET name = ?, breed = ?
      WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
       if !dog.empty?
         n_dog = Dog.new(id: dog[0][0], name: dog[0][1], breed: dog[0][2])
       else
      dog = self.create(name: name, breed: breed)
      dog
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM dogs WHERE dogs.name = ?
    SQL
    results = DB[:conn].execute(sql, name)
    dog = Dog.new(id: results[0][0], name: results[0][1], breed: results[0][2] )
  end

end
