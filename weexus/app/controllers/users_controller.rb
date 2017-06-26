class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => :profile
  before_action :authenticate_user!, :set_user, only: [:show, :edit, :update, :destroy]
  include UsersHelper
  helper_method :sort_column , :sort_direction

  # GET /users
  # GET /users.json
  def index
    @users = User.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(post_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to '/', notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(post_params)
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def profile
    @posts=Post.where(user: current_user.id, status: 'Done').or(Post.where(user: current_user.id, status: 'Submitted')).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.require(:user).permit(:name, :email, :terms_accepted)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:user).permit(:email, :role, :username, :password, :password_confirmation)
    end
end
