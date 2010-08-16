Houdini Sinatra App
================================
This is a simple CRUD Sinatra app with Houdini Mechanical Turk API integration. The image is sent to Houdini for moderation in an after create callback on the Image model.

If you'd like to run the app yourself, you can follow the directions below.


Installation
================================

    git clone git://github.com/chrisconley/houdini-sinatra-example.git
    cd houdini-sinatra-example
    gem install bundler -v 1.0.0.rc.5
    bundle install

Lastly, you'll need to change the "HOUDINI_API_KEY" and "SINATRA_HOST" constants. If you need an api key, please email us at presto@houdinihq.com.

To run the app
--------------------------------

    cd houdini-sinatra-example
    rackup

To run the tests
--------------------------------

    cd houdini-sinatra-example
    ruby test.rb

