Houdini Sinatra App
================================
This is a simple CRUD Sinatra app with Houdini Mechanical Turk API integration. The image is sent to Houdini for moderation in an after create callback on the Image model.

If you'd like to run the app yourself, you can follow the directions below.


Installation
================================

    git clone git://github.com/chrisconley/cat_or_not.git
    cd cat_or_not
    bundle install

Lastly, you'll need to change the "HOUDINI_API_KEY" and "SINATRA_HOST" constants. If you need an api key, please email us at presto@houdinihq.com.

To run the app
--------------------------------

    rackup

To run the tests
--------------------------------

    bundle exec ruby test.rb

