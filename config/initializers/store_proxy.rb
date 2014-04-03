class StoreProxy < Rack::Proxy
  USE = :remote
  LOCAL_URL = 'localhost:3001'
  REMOTE_URL = 'cocoa-tree.github.io:80'

  def rewrite_env(env)
    if USE == :remote
      env["HTTP_HOST"] = REMOTE_URL
    else
      env["HTTP_HOST"] = LOCAL_URL
      env["SCRIPT_NAME"] = env["SCRIPT_NAME"].gsub("/store", "")
      env["REQUEST_URI"] = env["REQUEST_URI"].gsub("/store", "")
    end
    env
  end
end