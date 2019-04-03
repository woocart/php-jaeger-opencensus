#!/usr/bin/env bash
# shellcheck disable=SC2046,SC2086,SC2035
set -e

cd /var/www/public_html

while ! mysqladmin --user="$WORDPRESS_DB_USER" --password="$WORDPRESS_DB_PASSWORD" --host="$WORDPRESS_DB_HOST" ping --silent &> /dev/null ; do

    jq -ncsM \
        --arg kind "wp-cli" \
        --arg msg "Waiting for database connection..." \
        --arg ref 'wp-cli db wait --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST' \
        '{kind: $kind, msg: $msg, ref: $ref}'
    sleep 1
done

wp-cli config create --dbname="$WORDPRESS_DB" --dbuser="$WORDPRESS_DB_USER" --dbpass="$WORDPRESS_DB_PASSWORD" --dbhost="$WORDPRESS_DB_HOST" --force --extra-php <<PHP
require_once('/vendor/vendor/autoload.php');
if (php_sapi_name() !== 'cli') {
    \OpenCensus\Trace\Integrations\Wordpress::load();
    \OpenCensus\Trace\Integrations\Mysql::load();
    \OpenCensus\Trace\Integrations\Curl::load();

    opencensus_trace_method('wpdb', 'query');
    \OpenCensus\Trace\Tracer::start(new \OpenCensus\Trace\Exporter\JaegerExporter('WordPress', ["host" => "tracing"]));
}

define('WP_HOME', 'http://localhost');
define('WP_SITEURL', 'http://localhost');

PHP