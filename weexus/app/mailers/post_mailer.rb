class PostMailer < ApplicationMailer
  default from: 'noreply@weexus.com'

  def post_submitted(user)
    @user = user
    mail(to:@user.email, subject: 'Thanks for sharing your experience')
  end
end
