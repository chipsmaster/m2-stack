# m2-stack

Docker stack for magento 2.4

Also a template for M2 projects

## Setup

* Run `make` to check docker installation and initiate environment
* (Optional) check/customize `.env` and `docker-compose.override.yml`
* Put magento source root as `src` directory, or setup code later
* Run `make up` to run the stack in foreground (ctrl+c to stop)
* Add any required hosts to /etc/hosts, by default only `127.0.0.1   www.m2-stack.local`
* When `src` contains magento code, install magento:
    * Get into the php-fpm container (`make bash`)
    * (Optional) deploy sample data (`bin/magento sampledata:deploy`)
    * Run the install command line, example:
    ```
    bin/magento setup:install \
        --base-url=http://www.m2-stack.local/ \
        --db-host=mariadb --db-name=magento --db-user=magento --db-password=magento \
        --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com \
        --admin-user=admin --admin-password=admin123 \
        --language=fr_FR --currency=EUR --timezone=Europe/Paris \
        --use-rewrites=1 \
        --search-engine=elasticsearch7 --elasticsearch-host=elasticsearch --elasticsearch-port=9200
    ```

### Setup M2 code by composer

Remove any src contents and run the composer command inside the php-fpm container
* `rm -rf src/*`
* `make bash`
* Inside container: `composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/magento`
* Your keys will be asked (public key as username, private key as password) https://devdocs.magento.com/guides/v2.4/install-gde/prereq/connect-auth.html
* Then install magento by command line

### Install sample data

In case sample data not set up before installation :
* Inside container (make bash):
    * `bin/magento sampledata:deploy`
    * `bin/magento setup:upgrade`

### Post installation

To use Redis (inside container):
```
bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis --session-save-redis-log-level=4 --session-save-redis-db=2
```

Disable two factor authentication (inside container): 
```
bin/magento module:disable Magento_TwoFactorAuth
```

### Access

* Front: http://www.m2-stack.local/
* BO: (path given in env.php)
* Mailcatcher: http://localhost:1080/
