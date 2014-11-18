module ApplicationHelper
  def flash_class(level)
    case level
      when :notice then "alert alert-success"
      when :warn then "alert alert-warning"
      when :info then "alert alert-info"
      else "alert alert-danger"
    end
  end
end
