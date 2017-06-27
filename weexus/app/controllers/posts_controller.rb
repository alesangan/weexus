class PostsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:show, :index, :upvote]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  include PostsHelper
  helper_method :sort_column , :sort_direction

  # GET /posts
  # GET /posts.json
  def index
    if params[:search]
      @posts = Post.where(status: 'Done').search(params[:search]).order("created_at DESC").order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
    else
      @posts = Post.where(status: 'Done').order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
    end
  end

  def review
    @posts = Post.where(status: 'Submitted').order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
  end

  def rejected
    @posts = Post.where(status: 'Rejected').order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 5)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    exclusion_list = Exclusion.all.map{|m| [m.word]}
    string =  @post.content

    jqtagcloud = Jqtagcloud.new
    @tag_cloud = jqtagcloud.createCloud(string, exclusion_list, 45)
  end

  # GET /posts/new
  def new
    @tag_options = Tag.select{ |t| t.status == "Active"}.map{ |t| [t.name]} #AH NEW
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @tag_options = Tag.select{ |t| t.status == "Active"}.map{ |t| [t.name]} #AH NEW
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.status = 'Submitted'
    @post.split_tag_list(params[:tags])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        PostMailer.post_submitted(@post.user).deliver
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        @tag_options = Tag.select{ |t| t.status == "Active"}.map{ |t| [t.name]} #AH NEW
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if params[:tags] != nil
        @post.split_tag_list(params[:tags])
      end
      if @post.update(post_params)
        if post_params[:status]=="Rejected"
          PostMailer.post_rejected(@post.user).deliver
        end
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.tags.clear
    @post.destroy
    #@post.split_tag_list(params[:tags])
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end


  def upvote
    authenticate_user!
    @post = Post.find(params[:id])
    @post.liked_by current_user
    redirect_to :back
    authorize! :upvote, @post
  end

  def downvote
    @post = Post.find(params[:id])
    @post.unliked_by current_user
    redirect_to :back
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :status, :user_id)
    end
end

def sort_column
  %w[title created_at cached_votes_total].include?(params[:sort]) ? params[:sort] : "title"
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
end
