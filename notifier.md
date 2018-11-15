# Notifier

_Notifier_ app monitors the weather in your area and will notify you when
a weather alert is declared. The notification happens in the form a webhook to
provide flexibility and timeliness.

[Wikipedia](https://en.wikipedia.org/wiki/Webhook) defines webhooks as:

> A webhook in web development is a method of augmenting or altering the
> behaviour of a web page, or web application, with custom callbacks. These
> callbacks may be maintained, modified, and managed by third-party users and
> developers who may not necessarily be affiliated with the originating website
> or application.

[Zapier](https://zapier.com/blog/what-are-webhooks/) offers this helpful illustration:

> There are two ways your apps can communicate with each other to share
> information: polling and webhooks. As one of our customer champion's friends
> has explained it: Polling is like knocking on your friend’s door and asking
> if they have any sugar. Webhooks are like someone tossing a bag of sugar at
> your house whenever they buy some.

Your role as the lead developer is to create the Notifier application using
Voyage, Headway's Rails application template. You will be pairing with another
developer during this exercise and your customers are other developers.
Notifier will provide other devs with a simple tool that can be used to alert
their customers of any weather concerns.

## Priorities

We are tasked with developing the Notifier app with the following priorities in mind:

1. Resilient: Notifier must be immune to common network and user errors
2. Timely: Notifier must notify a user at the earliest possible moment to promote public safety
3. Scalable: Notifier must support 10's of thousands of users

## Architecture

A `Webhook` is composed of the following attributes:

- `name`
  - `name` will be restricted to one of "watch" or "warning"
- `url`
  - `url` will be the Web address to send an HTTP GET request to
- `zip_code`
  - `zip_code` is the region within the US that a user would like to monitor for weather changes

Each attempt (i.e. HTTP request) to perform a webhook will result in
a `WebhookEvent` database record. The `WebhookEvent` model will be composed of
the following attributes:

- `webhook_id`
  - `webhook_id` will associate a `WebhookEvent` to a `Webhook`
- `status`
  - `status` will store the HTTP response code received from executing the `Webhook`
- `response`
  - `response` will store the HTTP response body received from executing the `Webhook`

`WeatherCheckService` is responsible for retrieving weather updates and
generating webhook events.

## Getting Started

We will be test driving the development of this application. The weather
service we will be using is available at `https://weather-alerts.com/api` (not
actually a real address) and the weather is always the same in the following
zip codes:

- 10000: quiet
- 20000: watch
- 30000: warning

weather-alerts.com returns JSON in the following format:

```
{
  zip_code: '#####',
  status: (quiet|watch|warning)
}
```

Begin this exercise by running `spec/services/weather_check_service_spec.rb`
and work to get the examples to pass.

## Goals

The goal of this exercise is to have a well-tested application that is
resilient, timely, and scalable, not necessarily an application that is feature
complete since our time is limited - three hours or less should be sufficient.

Questions are always welcome so please don't hesitate to ask and remember to
commit early and often.
