class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, :set_post, only: [:show, :edit, :update, :destroy]



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
    @get_exclusion_list = Exclusion.all.map{|m| [m.word]}
    string =  ActionView::Base.full_sanitizer.sanitize(@post.content)
    exclusion_list=@get_exclusion_list.flatten
    words = string.downcase.gsub /\W+/, ' '
    counts = Hash.new 0
    words.split(' ').each do |word|
      if word.length > 3
        counts[word] += 1
      end
    end
    counts = counts.sort_by {|_key, value| value}.reverse.to_h
    hashnew = counts.reject { |k, _| exclusion_list.include? k }
    #  raise hashnew.inspect
    arrnew = Array.new
    counter = 25
    hashnew.each do|key,weight|
      hashp=Hash.new
      hashp['text'] = key
      hashp['weight']= weight
      arrnew.push(hashp)
      counter = counter - 1
      if counter==0
        break
      end
    end

    @tag_cloud = arrnew

  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end


  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.status = 'Submitted'
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
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
