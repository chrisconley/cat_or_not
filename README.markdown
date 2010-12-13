Houdini Sinatra App
================================
This is a simple CRUD Sinatra app with Houdini Mechanical Turk API integration. The image is sent to Houdini for moderation in an after create callback on the Image model.

If you'd like to run the app yourself, you can follow the directions below.


Installation
================================

    git clone git://github.com/chrisconley/cat_or_not.git
    cd cat_or_not
    bundle install

Next, you'll need to change the following constants in config.ru:

* HOUDINI_API_KEY: If you need an api key, you can sign up at houdiniapi.com/sign-up.
* APP_HOST: The domain that Houdini will post answers back to. (Check out tunnlr.com for testing locally.)

To run the app
--------------------------------

    rackup

And start up tunnlr to receive postbacks from Houdini if testing locally.

To run the tests
--------------------------------

    bundle exec ruby test.rb

