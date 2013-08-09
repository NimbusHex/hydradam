class TrackingEvent < ActiveRecord::Base
  belongs_to :user

  validates :event, inclusion: %w(view download)
  validates :pid, presence: true
end
