require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'volunteer_tracker'})

# Projects --------------------------------------->

get('/') do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

get('/projects/new') do
  erb(:new_project)
end

post('/projects') do
  title = params[:title]
  project = Project.new({:title => title, :id => nil})
  project.save()
  @projects = Project.all
  erb(:projects)
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update({title: params[:title]})
  @projects = Project.all
  erb(:projects)
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.delete()
  @projects = Project.all
  erb(:projects)
end

# Volunteers---------------------------------->

get('/volunteers') do
  @volunteers = Volunteer.all
  erb(:volunteers)
end

get('/volunteers/new') do
  erb(:new_volunteer)
end

post('/volunteers') do
  name = params[:name]
  project_id = params[:project_id]
  volunteer = Volunteer.new({:name => name, :project_id => project_id, :id => nil})
  volunteer.save()
  @volunteers = Volunteer.all
  erb(:volunteers)
end

get('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  erb(:volunteer)
end

patch('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  name_update = params[:volunteer_name]
  project_id = params[:project_id]
  @volunteer.update(name_update, project_id)
  @volunteers = Volunteer.all
  erb(:volunteers)
end

delete('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  @volunteer.delete()
  @volunteers = Volunteer.all
  erb(:volunteers)
end


get('/projects/:id/volunteers/:volunteer_id') do
  @volunteer = Volunteer.find(params[:volunteer_id].to_i())
  erb(:volunteer)
end


post('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.new({:name => params[:volunteer_name], :project_id => @project.id, :id => nil})
  volunteer.save()
  erb(:project)
end


patch('/projects/:id/volunteers/:volunteer_id') do
  @project = Project.find(params[:id].to_i())
  volunteer = Volunteer.find(params[:volunteer_id].to_i())
  volunteer.update(params[:volunteer_name], @project.id)
  erb(:project)
end


delete('/projects/:id/volunteers/:volunteer_id') do
  volunteer = Volunteer.find(params[:volunteer_id].to_i())
  volunteer.delete
  @project = Project.find(params[:id].to_i())
  erb(:project)
end