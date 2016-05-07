class Challenge < ActiveRecord::Base
  extend FriendlyId
  include ActiveRecord::QueryMethods
  friendly_id :title, use: [:slugged, :finders]
  rails_admin do
    configure :slug do
      read_only true
    end
  end

  has_one :panel
  has_one :experience_stage
  has_one :idea_stage
  has_one :recipe_stage
  has_one :solution_stage

  mount_uploader :banner, ImageUploader
  process_in_background :banner

  def self.featured
    where(featured: true).where('starts_at < ?', Time.now).where('ends_at > ?', Time.now).first
  end

  def panelists
    panel.users
  end

  def featured_contributions
    case active_stage
    when 'experience'
      experience_stage.experiences.published.first(2)
    when 'idea'
      idea_stage.ideas.published.where(inspiration: false).first(3)
    when 'recipe'
      recipe_stage.recipes.published.first(2)
    when 'solution'
      solution_stage.solutions.first(2)
    else
      nil
    end
  end

  def has_featured_for(type)
    Feature.exists?(featureable_type: type, active: true, challenge_id: id)
  end

  def stage_number
    case active_stage
    when 'experience'
      1
    when 'idea'
      2
    when 'recipe'
      3
    when 'solution'
      4
    else
      1
    end
  end

  STAGES = [
    {
      number: 1,
      name: 'experience',
      action: 'shared',
      icon: 'fa-comment',
      headline: 'Share Experiences',
      description: 'Tell others about your experience with this challenge.'
    },
    {
      number: 2,
      name: 'idea',
      action: 'contributed',
      icon: 'fa-lightbulb-o',
      headline: 'Contribute Ideas',
      description: 'Contribute and compare ideas you might use to solve this challenge.'
    },
    {
      number: 3,
      name: 'recipe',
      action: 'developed',
      icon: 'fa-flask',
      headline: 'Develop Recipes',
      description: 'Develop and propose different recipes to tackling this challenge.'
    },
    {
      number: 4,
      name: 'solution',
      action: 'tried',
      icon: 'fa-puzzle-piece',
      headline: 'See Your Solutions',
      description: 'See stories of how real schools have adopted the solutions you’ve inspired, or try them out yourself!'
    }
  ].freeze

end
