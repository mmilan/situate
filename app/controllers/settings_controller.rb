class SettingsController < ApplicationController
  def account
    @user = Current.user
  end

  def update_account
    @user = Current.user

    if @user.update(account_params)
      redirect_to settings_account_path, notice: "Account updated successfully."
    else
      render :account, status: :unprocessable_entity
    end
  end

  def update_password
    @user = Current.user

    if !@user.authenticate(params[:current_password])
      @user.errors.add(:current_password, "is incorrect")
      render :account, status: :unprocessable_entity
    elsif @user.update(password_params)
      redirect_to settings_account_path, notice: "Password updated successfully."
    else
      render :account, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:user).permit(:username, :email_address)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
