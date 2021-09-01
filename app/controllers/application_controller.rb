class ApplicationController < ActionController::Base
  def hello
    render json: {index: 'hello'}
  end
end
