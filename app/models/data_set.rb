class DataSet < ApplicationRecord
  belongs_to :region
  belongs_to :competition

  validates :name, presence: true

  def self.search(term)
    results = []
    DataSet.all.each do |data_set|
      data_set_string = "#{data_set.name} #{data_set.url} #{data_set.description}".downcase
      results << data_set if data_set_string.include? term.downcase
    end
    results
  end

  def self.data_set_project_helper
    data_set_urls = all.pluck(:url)
    team_data_sets = TeamDataSet.where(url: data_set_urls)
    team_ids = team_data_sets.pluck(:team_id)
    id_teams_projects = Team.id_teams_projects(team_ids)
    url_to_project_names = {}
    data_set_urls.each { |url| url_to_project_names[url] = [] }
    team_data_sets.each do |team_data_set|
      project = id_teams_projects[team_data_set.team_id][:current_project]
      url_to_project_names[team_data_set.url] << project.project_name
    end
    url_to_project_names
  end

  require 'csv'

  def self.to_csv(options = {})
    data_set_columns = %w[name url description]
    combined = data_set_columns + ['projects']
    url_to_project_names = data_set_project_helper
    CSV.generate(options) do |csv|
      csv << combined
      all.each do |data_set|
        data_set_values = data_set.attributes.values_at(*data_set_columns)
        csv << (data_set_values + [url_to_project_names[data_set.url]])
      end
    end
  end
end
