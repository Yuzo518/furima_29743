module SignInSupport
  def sign_in(user)
    # ログインページへ遷移する
    visit new_user_session_path
    # 正しい情報を入力する
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    # ログインボタンを押す
    click_on("ログイン")
    # トップページへ遷移することを確認する
    expect(current_path).to eq root_path
  end
end