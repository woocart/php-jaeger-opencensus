# WordPress execution metrics with OpenCensus

This stack enables you to track performance of any WordPress install.

For more read our article on <https://blog.woocart.com/performance-tracing>.

## Setup

1. Drop your WordPress install to `public_html` folder.
2. Run `docker-compose up`
3. Import your database backup via PHPMyAdmin running on <http://localhost:81>.

## Exposed services

WordPress <http://localhost>

PHPMyAdmin <http://localhost:81>

Jeager <http://localhost:82>