#!/usr/bin/env bash

# Setup critical base information
project="$(basename "$(realpath .)" | sed -e 's/docker-//')"
tag="$(git branch --show-current)"

# build the image, run it as "build-readme"
docker build --rm -t "mck7/${project}:${tag}" .
docker rm -f build-readme
docker run -itd --name build-readme "mck7/${project}:${tag}"

# Collect information
php_module="$(docker exec -it build-readme bash -c "php -m")"
php_version="$(docker exec -it build-readme bash -c "php -v")"
apache_version="$(docker exec -it build-readme bash -c "apachectl -V")"
apache_module="$(docker exec -it build-readme bash -c "apachectl -M")"
headings="$(head -n2 README.md)"

# Begin the README output
echo "${headings}" > README.md

# Send the Apache version information
echo "
## Apache Version Information
" >> README.md
echo '```' >> README.md
echo "${apache_version}" >> README.md
echo '```' >> README.md

# Send the Apache module information
echo "
## Apache Module Information
" >> README.md
echo '```' >> README.md
echo "${apache_module}" >> README.md
echo '```' >> README.md

# Send the PHP version information
echo "
## PHP Version Information
" >> README.md
echo '```' >> README.md
echo "${php_version}" >> README.md
echo '```' >> README.md

# Send the php module information
echo "
## PHP Module Information
" >> README.md
echo '```' >> README.md
echo "${php_module}" >> README.md
echo '```' >> README.md
