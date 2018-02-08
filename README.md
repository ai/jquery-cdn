# DEPRECATED: Best way to load latest jQuery in Ruby

**This project is depreacted. Use Node.js build tools instead of Sprockets.**

Load jQuery from CDN in production and use local copy in development.
jQuery-CDN supports Ruby on Rails, Sinatra and other non-Rails environments
with Sprockets.

Another gem [jquery-rails](https://github.com/rails/jquery-rails) contains also
UJS adapter for jQuery. So it need to test any jQuery updates and will release
new jQuery version after few month (for example, there is still no jQuery 2
in `jquery-ujs`). If you don’t need UJS, this gem will be better for you.

jQuery-CDN now has 2 branches: with jQuery 2.x and 1.x.

## Features

### Load from CDN

Public CDN is a best way to serve jQuery:

* **Speed**: users will be able to download jQuery from the closest physical
  location.
* **Caching**: CDN is used so widely that potentially your users may not need
  to download jQuery at all.
* **Parallelism**: browsers have a limitation on how many connections can
  be made to a single host. Using CDN for jQuery offloads a big one.

In development gem will use local copy of jQuery, so you can develop app
in airplane without Internet. In production gem will use CDN,
but if it will down, gem will automatically fallback to bundled jQuery.

### Latest version of jQuery

Instead of `jquery-rails` this gem always contain latest version of jQuery,
because it doesn’t need to test compatibility with UJS adapter.

For example, `jquery-rails`
[doesn’t support](https://github.com/rails/jquery-rails/issues/124)
jQuery 2 even after 4 months.

### Gem version is same that jQuery

Instead of `jquery-rails`, this gem versions tell exactly what jQuery is inside.
`Gemfile` maintaining will be much easy:

```ruby
gem 'jquery-cdn', '1.10.2' # Use jQuery 1.10.2
```

### Sinatra and plain Ruby support

You can use jQuery-CDN with Ruby on Rails, Sinatra or any other Ruby environment
with Sprockets.

## How To

### Ruby on Rails

Add `jquery-cdn` gem to your `Gemfile`:

```ruby
gem 'jquery-cdn'
```

If you support IE 6, 7 or 8, lock jQuery in 1.x versions:

```ruby
gem 'jquery-cdn', '~> 1.0'
```

Call `include_jquery` helper in layout:

```haml
!!! 5
%html
  %head
    %title My site
    = include_jquery
    = javascript_include_tag('application')
```

### Ruby

If you use Sinatra or other non-Rails frameworks with Sprockets,
just connect your Sprockets environment to jQuery-CDN:

```ruby
require 'jquery-cdn'

assets = Sprockets::Environment.new do |env|
  # Your assets settings
end

JqueryCdn.install(assets)
```

Set local jQuery URL (by default, `/assets/jquery.js`):

```ruby
JqueryCdn.local_url = proc { '/jquery.js' }
```

Include `JqueryCdn::Helpers` module to your app:

```ruby
class YourApp < Sinatra::Base
  helpers { include JqueryCdn::Helpers }
end
```

And use `include_jquery` helper with `env` option:

```haml
!!! 5
%html
  %head
    = include_jquery(env: app.environment)
```

## Options

Helper `include_jquery` has 2 options:

* `env`: CDN will be used only in `:production` environment. Rails helper can
  detect it automatically. By default, `:production`.
* `cdn`: CDN to use. By default, `:google`.

Other options will be used as `<script>` attributes.

## CDNs

By default, gem use Google CDN, but you can change it by `cdn` option:

```haml
= include_jquery cdn: :yandex
```

You can use `:google`, `:microsoft`, `:jquery`, `:yandex` or `:cloudflare` CDN.

## Defer

Scripts with [defer](https://hacks.mozilla.org/2009/06/defer/) attribute will be
executed only after `<body>` loading. They increase perfomance, because scripts
without `defer` block DOM parsing, until script is downloading.

This attribute works like you put `<script>` tags to end of `<body>`.
But `defer` is better, because scripts downloading will start early.

So, `defer` attributes is highly recommended, but you need add it to all your
scripts.

```haml
!!! 5
%html
  %head
    %title My site
    = include_jquery(defer: true)
    = javascript_include_tag('application', defer: true)
```

Note, that unfortunately jQuery-CDN can’t use fallback with `defer` now,
because this options can’t work with inline scripts.

### Fallback

According to Murphy’s Law, even Google CDN may go down. So when you write
`include_jquery`, jQuery CDN inserts:

```html
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script>
<script>window.jQuery || document.write(unescape('%3Cscript src="/assets/jquery.js">%3C/script>'))</script>
```

This HTML checks, is jQuery normally loaded from Google. On any problems it will
load local copy of jQuery.
