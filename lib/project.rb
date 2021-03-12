class Project
  attr_reader :id, :title

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def self.all
    returned_projects = DB.exec('SELECT * FROM projects')
    projects = []
    returned_projects.each() do |project|
      title = project.fetch('title')
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
    self.title() == project_to_compare.title()
  end

  def self.clear
    DB.exec('DELETE FROM projects *;')
  end

  def self.find(id)
  project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    title = project.fetch("title")
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

  def volunteers
    volunteers = []
    results = DB.exec("SELECT project_id FROM volunteers WHERE project_id = #{@id};")
    results.each() do |result|
      project_id = result.fetch("project_id").to_i()
      volunteer = DB.exec("SELECT * FROM volunteers WHERE project_id = #{project_id};")
      name = volunteer.first().fetch("name")
      id = volunteer.first().fetch("id").to_i
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers
  end

end