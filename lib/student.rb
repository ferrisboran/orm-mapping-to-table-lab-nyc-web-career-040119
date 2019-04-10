require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  @@all = []

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.all
    @@all
  end

  def self.create_table
    sql = "CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def new_student(name, grade)
    sql = "INSERT INTO students(name, grade) VALUES ('#{name}', '#{grade}')"
    # @student_id = "SELECT id FROM students WHERE name = '#{name}'"
    DB[:conn].execute(sql)
  end

  def save
    # Be able to write over ID# in Student instance & not screw up prior tests
    def id=(id)
      @id = id
    end
    # Call on the new_student method and insert the name and grade from the last student added to the @@all array
    new_student(Student.all.last.name, Student.all.last.grade)
    # Save new sqlite command to grab the ID number from the last student added to the table
    student_id = "SELECT id FROM students WHERE name = '#{Student.all.last.name}'"
    # Send the student_id variable to SQL database to grab the ID#. Comes back as nested arrays
    @id = DB[:conn].execute(student_id).flatten!.first
    # Save the ID number that came back to the Student it was called on. Now looking at Student.all will show the ID number instead of nil
    Student.all.last.id = @id
    # binding.pry
    # 0
  end

  def self.create(name:, grade:)
    Student.new(name, grade)
    Student.all.last.save
    Student.all.last
  end

end
