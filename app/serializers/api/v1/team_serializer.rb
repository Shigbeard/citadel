module API
  module V1
    class TeamSerializer < ActiveModel::Serializer
      type :team

      attributes :id, :name, :description
      attribute(:avatar_url) { object.avatar.url }
      attribute(:avatar_thumb_url) { object.avatar.thumb.url }
      attribute(:avatar_icon_url) { object.avatar.icon.url }

      # has_many :users, key: :players, serializer: UserSerializer
      attribute :players do
        object.users.map do |user|
          {
            id: user.id,
            name: user.name,
            description: user.description,
            created_at: user.created_at,
            steam_32: user.steam_32,
            steam_64: user.steam_64,
            steam_id3: user.steam_id3,
            steam_64_str: user.steam_64.to_s,
            profile_url: user.avatar.thumb.url,
            captain: user.can?(:edit, object)
          }
        end
      end


      has_many :rosters, serializer: V1::Leagues::RosterSerializer
    end
  end
end
