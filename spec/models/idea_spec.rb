require 'rails_helper'
require 'models/concerns/embeddable_concern'
require 'models/concerns/url_normalizer_concern'
require 'models/concerns/publishable_concern'
require 'models/concerns/feature_concern'
require 'models/concerns/default_ordering_concern'
require 'models/concerns/orderable_concern'

describe Idea do

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  # it { is_expected.to validate_length_of(:description).is_at_most(1024)}
  # it { is_expected.to validate_length_of(:impact).is_at_most(1024)}
  # it { is_expected.to validate_length_of(:implementation).is_at_most(1024)}

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:problem_statement) }
  it { is_expected.to belong_to(:refinement_parent).class_name('Idea') }
  it { is_expected.to have_many(:refinements).class_name('Idea').with_foreign_key('refinement_parent_id') }
  it { is_expected.to have_one :feature }

  it_behaves_like 'embeddable'
  it_behaves_like 'normalizable'
  it_behaves_like 'a publishable entity'
  it_behaves_like 'orderable'
  it_behaves_like 'an entity respecting the default order'

  let(:entity) {
    idea_stage = create(:idea_stage, challenge: challenge)
    problem_statement = create(:problem_statement, idea_stage: idea_stage)
    idea = create(:idea, problem_statement: problem_statement)

    idea
  }

  it_behaves_like 'a featurable entity'
end
