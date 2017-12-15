require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require './model.rb'

set :bind, '0.0.0.0'

enable :sessions

get '/' do
  @posts = Post.all.reverse
  erb :index
end

get '/new' do
  erb :new
end

get '/create' do
  # 글을 데이터베이스에 저장하고 루트페이지로 리다이렉트 해준다.
  Post.create(
    title: params["title"], # :title => params["title"]
    content: params["content"] # :content => params["content"]
  )

  redirect to '/'
end

# destroy와 update를 하기 위한 variable routing 연습 (hello, square)
get '/hello/:name' do
  @name = params[:name]
  erb :hello
end

get '/square/:number' do
  #/square/3
  #square.erb로 보내주고, 3 * 3 = 9 출력
  number = params[:number].to_i
  @result = number * number
  erb :square
end

get '/destroy/:id' do # 삭제하는 로직
  # Post를 지울꺼임.
  # post = Post.get("지우고 싶은 포스트의 id값") => post.destroy 하면 지워짐.
  # 1번글을 지우게 될꺼면
  # '/destroy/1' 이라고 되면 됨. => variable routing : 라우팅인데 변수 개념을 사용한다.
  # params[:id]를 통해서 지울 수 있다.

  post = Post.get(params[:id])
  post.destroy
  redirect to '/'
end

get '/edit/:id' do
  @post = Post.get(params[:id])
  erb :edit
end

get '/update/:id' do
  post = Post.get(params[:id])
  post.update(
    title: params[:title],
    content: params[:content]
  )

  redirect to '/'
end

get '/signup' do
  erb :signup
end

get '/register' do
  User.create(
    name: params["name"],
    email: params["email"],
    password: params["password"],
    story: params["story"]
  )

  redirect to '/'
end

get '/login' do
  erb :login
end

get '/login_session' do
  @messge = ""
  if User.first(email: params["email"])
    if User.first(email: params["email"]).password == params["password"]
      session[:email] = params["email"]
      redirect to '/'
    else
      @message = "비번이 틀렸어요."
    end
  else
    @messge = "해당하는 이메일의 유저가 없습니다."
  end
end

get '/logout' do
  session.clear
  redirect to '/'
end

get '/admin' do
  @users = User.all
  erb :admin
end

get '/myPage' do
  @userinfo = User.all(email: session[:email])
  erb :myPage
end

# def check_login
#   unless session[:email]
#     redirect to '/'
#   end
# end
