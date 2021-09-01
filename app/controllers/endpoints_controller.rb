class EndpointsController < ApplicationController
	before_action :authorized
	skip_before_action :authorized, only: [:login, :create]
	skip_before_action :verify_authenticity_token

  def create
		create_user = User.create(username: allowed_params[:username], password: allowed_params[:password])
		render json: create_user.errors, status: create_user.valid? ? :created : :bad_request
  end

  def login
		login_user = User.find_by(username: allowed_params[:username])
		if ( !login_user.nil? && login_user.authenticate(allowed_params[:password]) )
			login_user.generate_token
			render json: {token: login_user.token}, status: :ok
		else
			render json: {error: 'wrong username / password'}, status: :unauthorized
		end
  end

  def create_short_url
		created_short_link = Link.create(user_id: @user.id, url: allowed_params[:url])
		render json: created_short_link.valid? ? created_short_link.short_link : created_short_link.errors , status: created_short_link.valid? ? :ok : :bad_request
	end

	def get_url
		found_link = Link.find_by(user_id: @user.id, short_link: allowed_params[:link])
		redirect_to found_link.url if !found_link.nil?
	end

private

	def authorized
		@user = User.find_by(token: request.authorization)
		render json: {error: 'Invalid token'}, status: :unauthorized if ( request.authorization.nil? || @user.nil? )
	end

  def allowed_params
		params.permit(:username, :password, :url, :link)
  end

end
