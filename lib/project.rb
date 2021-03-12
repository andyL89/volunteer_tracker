class Project
  attr_reader :id, :title

  def initialize(attrs)
    @title = attrs.fetch(:title)
    @id = attrs.fetch(:id)
  end

  def self.all
    returned_projects = DB.exec('SELECT * FROM projects')
    projects = []
    returned_projects.each() do project|
      name = project.fetch('title')
      id = project.fetch('id').to_i
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def == (project_to_compare)
    self.name() == project_to_compare.name()
  end

  def self.clear
    DB.exec('DELETE FROM projects *;')
  end

  def self.find(id)
  project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    title = project.fetch("name")
    id = project.fetch("id").to_i
    Project.new({:title => title, :id => id})
  end

  def update(attributes)
    if (attributes.has_key?(:title)) && (attributes.fetch(:title) != nil)
      @title = attributes.fetch(:title)
      DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
    end
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

end