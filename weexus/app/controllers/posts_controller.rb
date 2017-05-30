class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, :set_post, only: [:show, :edit, :update, :destroy]
  include PostsHelper

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where(status: 'Done')
  end

  def review
    @posts = Post.where(status: 'Submitted')
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @tag_options = Tag.all.map{ |t| [t.name]}  #AH NEW
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @tag_options = Tag.all.map{ |t| [t.name]}
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
    @post.liked_by current_user
    redirect_to :back
  end

  def downvote
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
