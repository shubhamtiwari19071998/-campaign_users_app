class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def filter
    campaign_names = params[:campaign_names]
    if campaign_names
      campaign_names = campaign_names.split(',')
      query = campaign_names.map do |campaign_name|
        "JSON_CONTAINS(campaigns_list, '{\"campaign_name\": \"#{campaign_name}\"}', '$')"
      end.join(" OR ")
      @users = User.where(query)
    end
    render json: @users
  end

  private

  def user_params
    # params.require(:user).permit(:name, :email, campaigns_list: [])
     params.require(:user).permit(:name, :email, campaigns_list: [:campaign_name, :campaign_id])
  end
end