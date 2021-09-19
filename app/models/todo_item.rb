class TodoItem < ApplicationRecord
  # default_scope { order(created_at: :desc) }
  belongs_to :user
  validates_presence_of :user
  validates :title, presence: true
  validates_length_of :title, maximum: 5000
  visitable :ahoy_visit

  # Returns a string .. formatted TodoItem created_at field
  def created
    "#{self.created_at.in_time_zone("#{self.user.timezone}").strftime('%m/%d/%Y')}"
  end

  # Returns a string .. formatted TodoItem updated_at field
  def updated
    "#{self.updated_at.in_time_zone("#{self.user.timezone}").strftime('%m/%d/%Y')}" # .. %H, %M, %S
  end

  # Returns a string .. strip out unknown characters, etc.. for title in word tree
  def strip_title_for_tree
    self.title
        .downcase
        .gsub(/[^a-z0-9\s]/i, ' ')
        .gsub(/[^0-9A-Za-z]/, ' ')
        .gsub(/and|are|but|can|for|from|has|have|had|too|the|there|very|way|where|who/, ' ')
  end

  # Returns an array .. class method: number of todoItems month over year
  def self.month_of_year_todos
           group_by_month_of_year(:created_at)
          .count
          .map{ |k, v| [I18n.t("date.month_names")[k], v] }
  end

end
