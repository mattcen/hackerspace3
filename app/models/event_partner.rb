class EventPartner < ApplicationRecord
  belongs_to :event
  belongs_to :sponsor
end
