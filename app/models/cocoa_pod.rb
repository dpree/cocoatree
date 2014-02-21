class CocoaPod < ActiveRecord::Base
  default_scope { order('stars DESC') }
  
  after_initialize :init_stars
  
  def init_stars
    self.stars ||= 0
  end
  
  def dependencies
    []
  end
  
  def serializable_hash context
    h = super
    h['pushed_at'] = h['pushed_at']
    h['created_at'] = h['created_at']
    h['updated_at'] = h['updated_at']
    h
  end
end