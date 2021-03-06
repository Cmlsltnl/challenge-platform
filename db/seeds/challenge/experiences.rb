challenge = Challenge.find(1)

links = ["https://youtube.com/watch?v=rzfhs3M4lus", "https://twitter.com/MrBronke/status/559780396225662977", "https://vimeo.com/82083297", "https://assets.entrepreneur.com/content/16x9/822/20150903173413-books-shop-fair-library-used-bookshelf-literature-study-textbooks.jpeg", "https://c4.staticflickr.com/4/3553/3421529389_005faf57a5_b.jpg", nil]

## CREATING DEMO EXPERIENCES
challenge.experience_stage.themes.each do |theme|
  15.times do |time|
    experience = theme.experiences.create!(
      description: Faker::Lorem.paragraph,
      user_id: (User.pluck(:id) - challenge.panelists.pluck(:id)).sample,
      published_at: time.days.ago
    )

    ## Creating comment threads for those ideas
    1+rand(8).times do
      comment = Comment.build_from(
        experience,
        User.pluck(:id).sample,
        { body: Faker::Lorem.sentence, link: links.sample }
      )
      comment.save!

      ## Nested comment
      nested = Comment.create!(
        commentable: experience,
        user: User.find(User.pluck(:id).sample),
        body: 'Nested: ' + Faker::Lorem.sentence,
        link: links.sample,
        temporal_parent_id: comment.id
      ) if [true, false].sample
    end
  end

  feature = Feature.create!(
    user_id: challenge.panelists.pluck(:id).sample,
    featureable: theme.experiences.sample,
    active: true,
    challenge: challenge,
    reason: Faker::Hacker.say_something_smart
  )
end
