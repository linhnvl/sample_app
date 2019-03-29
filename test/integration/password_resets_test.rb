require "test_helper"

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :linh
  end

  test "password resets" do
    get new_password_reset_path
    assert_template "password_resets/new"

    # Invalid email
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.blank?
    assert_template "password_resets/new"

    # Valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.blank?
    assert_redirected_to root_path

    # Password reset form
    user = assigns :user

    # Wrong email
    get edit_password_reset_path user.reset_token, email: ""
    assert_redirected_to root_path

    # Inactive user
    user.toggle! :activated
    get edit_password_reset_path user.reset_token, email: user.email
    assert_redirected_to root_path
    user.toggle! :activated

    # Right email, wrong token
    get edit_password_reset_path "wrong token", email: user.email
    assert_redirected_to root_path

    # Right email, right token
    get edit_password_reset_path user.reset_token, email: user.email
    assert_template "password_resets/edit"
    assert_select "input[name=email][type=hidden][value=?]", user.email
  end
end
