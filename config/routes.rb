Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/api/minify/closure_compiler', to: 'minify#closure_compiler'
  post '/api/minify/uglify', to: 'minify#uglify'
end
