# Simple PHP MQTT Client Docker Image

This repo are use to create docker image version of [my simple-php-mqtt-client github repo](https://github.com/sofyanarief/simple-php-mqtt-client). This image based on Linux Debian Buster with installed Apache2 web server, PHP 7.4, Composer, PHP-SQLite, curl, nano and supervisor.
No need to run mqtt-client-subs.php manually, since it loaded automatically at container startup by using supervisor.

## Installation
 1. Clone [this repo](https://github.com/sofyanarief/simple-php-mqtt-client-docker).
 2. Run docker build to build image.
 3. Create docker container from builded docker images.
 4. Access container that you have been created and customize mqtt-server-config according to [my original application repo](https://github.com/sofyanarief/simple-php-mqtt-client)
 5, Restart your container and enjoy.
