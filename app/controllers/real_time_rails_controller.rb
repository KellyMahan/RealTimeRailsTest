class RealTimeRailsController < ActionController::Base

  # Updates will pull data from this controller.
  # url in the form of '/render_real_time/id/#{md5_hash_id}'
  # The information is pulled from Rails.cache by the md5 hash id
  def update
    id = params[:id].to_s
    websocket_options = Rails.cache.read("real_time_#{id}")
    render_options = Rails.cache.read("real_time_#{id}_options")
    model = websocket_options[:model]
  
    data = case model[:type]
    when :single, "update"
      case params[:rtr_action]
      when "update"
        eval(model[:name]).find(model[:id]) rescue nil
      when "destroy"
        eval(model[:name]).new
      end
    when :array
      eval(model[:name]).where(id: model[:ids]).to_a
    when :relation
      eval(model[:name]).find_by_sql(model[:sql].gsub(/\\/,""))
    end
    locals = render_options[:locals].merge(model[:key] => data)
  
    render partial: render_options[:partial], locals: locals
  end
end  