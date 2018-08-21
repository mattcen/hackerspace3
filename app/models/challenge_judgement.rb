class ChallengeJudgement < ApplicationRecord
  belongs_to :challenge_scorecard
  belongs_to :challenge_criterion

  validates :score, numericality: { less_than_or_equal_to: MAX_SCORE,
                                    greater_than_or_equal_to: MIN_SCORE,
                                    only_integer: true }
end
