class PostMailer < ApplicationMailer
  default from: 'noreply@weexus.com'

  def post_submitted(user)
    @user = user
    mail(to:@user.email, subject: 'Thanks for sharing your experience')
  end

  def post_rejected(user)
    @user = user
    mail(to:@user.email, subject: 'Your post has been rejected')
  end
end
