class Event < ApplicationRecord
  has_many :assignments, as: :assignable
  has_many :registrations
  has_many :registration_assignments, through: :registrations, source: :assignment
  belongs_to :region
  belongs_to :competition
  has_one :event_partner

  validates :name, presence: true

  validates :registration_type, inclusion: { in: EVENT_REGISTRATION_TYPES }
  validates :category_type, inclusion: { in: EVENT_CATEGORY_TYPES }

  def host
    assignment = assignments.where(title: EVENT_HOST).first
    return assignment if assignment.nil?
    assignment.user
  end

  def supports
    supports = []
    assignments.where(title: EVENT_SUPPORT).each do |assignment|
      supports << assignment.user
    end
    supports
  end

  def attending(user)
    return true if registrations.find_by(assignment: user.event_assignment,
                                         status: INTENDING).present?
    false
  end

  def registered(user)
    return true if registrations.find_by(assignment: user.event_assignment).present?
    false
  end

  def vips
    registration_assignments.where(title: VIP)
  end

  def participants
    registration_assignments.where(title: PARTICIPANT)
  end

  def admin_assignments
    collected = assignments.where(title: EVENT_ADMIN).to_a
    collected << region.admin_assignments
    collected << competition.admin_assignments
    collected.flatten
  end
end
