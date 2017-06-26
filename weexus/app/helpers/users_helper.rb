module UsersHelper
  def post_params
    params.require(:post).permit(:title, :content, :status, :tag_list)
  end
end
