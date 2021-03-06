class UsersController < ApplicationController
  get '/users/comics' do
    @comics = current_user.comics
    erb :'/users/user_comics'
  end


  get '/signup' do
    if !logged_in?
      erb :'/users/create_user'
    else
      redirect to '/comics'
    end
  end

  post '/signup' do
    user = User.new(params) 
    if user.save
      flash[:notice] = "Thanks for signing up!"
      session[:user_id] = user.id
      redirect to '/comics'
    else 
      flash[:notice] = user.errors.full_messages.join
      redirect to '/signup' # redirect them to signup
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      redirect '/comics'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect '/comics'
      else
        flash[:notice] = "Invalid username or password"
        redirect to '/login'
      end
    else
      flash[:notice] = "This account does not exist. Please create one."
      redirect to '/signup'
    end
  end
  
  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
      flash[:notice] = 'Successfully logged out.'
    else
      redirect to '/'
    end
  end
end
