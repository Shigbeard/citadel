# Change to whichever league we're generating for
league = League.find(ARGV.first.to_i)

rosters = league.rosters.to_a

rosters_with_values = rosters.map do |roster|
  player_values = roster.users.map do |user|
    # Get highest placement in any roster for completed leagues
    completed = League.statuses[:completed]
    past_rosters = user.rosters
                       .includes(division: { league: :divisions })
                       .references(division: :league)
                       .where(leagues: { status: completed })
                       .to_a

    roster_values = past_rosters.map do |past_roster|
      league = past_roster.league
      value = past_roster.division.rosters.ordered(league).index(past_roster)

      past_roster.league.divisions.each do |div|
        break if div == past_roster.division
        value += div.rosters.size
      end

      value
    end

    roster_values.min || 40 # Arbitrary: Placement for new people
  end

  # Take root mean square to more accurately present carries
  player_values = player_values.map { |value| value**2 }
  rms_value = Math.sqrt(player_values.sum.to_f / player_values.size)

  [roster, rms_value]
end

rosters_with_values.sort_by! { |_, value| value }

rosters_with_values.each do |roster, value|
  puts "# Team: '#{roster.name}'"
  puts "Value:\t#{value}"
  puts "Desired Division:\t#{roster.division.name}"
  puts
  puts roster.description

  puts 'Roster:'
  roster.users.each do |user|
    user_p = UserPresenter.new(user, nil)
    puts "\t#{user.name}\t[[#{user.steam_id3}](#{user_p.steam_profile_url})]"
  end

  puts
end
