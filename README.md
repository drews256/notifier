# Notes

I'm pretty happy with the weather job. Not as much about the webhook job. I spent too much time getting weather probably not enough time spent on the webhook job.

I changed your webhook service so it is a job. I also didn't use ActiveJob I just wrote Sidekiq jobs.

I used HTTParty cause it's super easy. But I'd rather build out a better service to post out to those webhooks.

Tests are green minus the one we talked about.

Overall, I think the WeatherCheckService could use a little more error handling. But it's decoupled enough that I honestly doubt it would be too neccesary.

I broke into AS notifications to handle the messages from getting weather responses from the API and broadcasting those changes to the webhooks.

I think I was closeish on suggested time.

Also, it would be sweet to do a integration test to make sure everythign works nicely. But, I also didn't really mock anything, so I'd say I have some integration tests and could do a better job of isolating my objects.
# Notifier



## Getting Started

### Using the Template

Download the app from GitHub (this gives you an empty repo)

Bootstrap your application:

```shell
% ./bin/voyage
```

Run this setup script to set up your machine
with the necessary dependencies to run and test this app:


    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, Redis, etc.


## Seeded Data

Assuming that devise was opted in to, a user and admin have been seeded for you:

    admin@example.com -> asdfjkl123
    user_1@example.com -> asdfjkl123

## Static Pages

The HighVoltage gem is used.

## Authorization

This repo uses CanCanCan and Canard to authorize user action. `ApplicationController` defines the `check_authorization` method for non-devise non-high voltage controllers. If you want to skip authorization for a specific method in a controller, the following method can be used: `skip_authorization_check`

## Rubocop

Take a look at the `.rubocop.yml` file to see what styles are being enforced.

## Annotations

Model & spec files are automatically annotated each time `rake db:migrate` is run.

## Push Notifications

See https://www.notion.so/hdwy/Push-Notifications-eafb97c6a9e6438ea364efc086cbf7ca

# Set Heroku Config Vars

    heroku config:set FORCE_SEED=1
    heroku config:set REDIS_URL=''
    heroku config:set SEGMENT_ANALYTICS_RUBY_KEY=''
    heroku config:set SMTP_ADDRESS=''
    heroku config:set SMTP_DOMAIN=''
    heroku config:set SMTP_PASSWORD=''
    heroku config:set SMTP_USERNAME=''
    heroku config:set SIDEKIQ_USERNAME=''
    heroku config:set SIDEKIQ_PASSWORD=''
    heroku config:set APPLICATION_HOST='headway_rails_template.headway.io'

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    % ./bin/deploy staging
    % ./bin/deploy production

## Maintaining the Headway Rails Template

To keep our Rails template up to date with the latest libraries and security fixes:

1. Run `bundle update`.
2. Review recent releases of https://github.com/thoughtbot/suspenders/releases for changes of interest.
3. Check with team for relevant changes from other projects to bring into our template.
4. Run the test suite to ensure nothing's broken.
