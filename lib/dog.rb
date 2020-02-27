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
    # binding.pry
    id = array[0]
    name = array[1]
    breed = array[2]
    dog = self.new(id: id, name:, breed:)
    dog
  end

end
