# acrosstime

## target environments
Linux, Apache 2.2, PHP 5.5, MySQL 5.1  
staging: http://dev.acrossti.me/  
production: http://acrossti.me/  

## local development environment covered in guide
Ubuntu 12.04, Ubuntu 14.04, Windows 7  
Apache 2.4, PHP 5.5, MySQL 5.5  
local testing: http://l.acrossti.me/

**This is a virtualhost setup on your local development environment.**

### differences between environments

The "local development" environment is one where error output has been enabled 
in PHP and Symfony is running in debug mode. Ideally, if you have the xdebug 
PHP extension, you will also be able to set breakpoints and step through code 
to more effectively isolate issues.

If something works in the "local development" environment, there's no reason 
for it to fail in your "local testing" environment save server configuration 
issues (e.g. misconfigured Apache virtualhost).

Both "staging" and "production" environments have PHP error output suppressed 
and Symfony running in production mode. The "staging" environment is designed 
to be a non-live system running test data (possibly a snapshot of the live 
database) to allow for testing on production hardware.

## requirements

* php >= 5.5
* mcrypt php extension
* mysql server >= 5.1
* pdo and pdo_mysql php extensions
* apache2
* apache2 php5 module
* apache2 mod_rewrite

## setup on ubuntu linux

### ubuntu 12.04 and 14.04

Install the required packages:

    sudo apt-get install php5 php5-mysql php5-mcrypt apache2 libapache2-mod-php5 mysql-server

### ubuntu 12.04

You will have to add a PPA to fulfill the `php >= 5.5` requirement. 
[Ondřej Surý's PPA for PHP 5.5](https://launchpad.net/~ondrej/+archive/ubuntu/php5) 
is recommended. 

To add the PPA for PHP 5.5:

    sudo add-apt-repository ppa:ondrej/php5

After that:

    sudo apt-get update
    sudo apt-get install php5 php5-mcrypt

### nginx

Nginx works fine as an alternative to Apache for development, but setting it up 
correctly involves some extra configuration wizardry. In particular, `php5-fpm` 
(FastCGI Process Manager) should be installed and nginx needs to have the 
correct permissions to run it. Some additional work may be required to ensure 
`php5-fpm` is running the `mcrypt` module. These details are left out of the 
guide for now.

### (recommended) install composer globally

To install `composer` globally to your `$PATH`: 

    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin

If you change the `install-dir`, make sure the directory is in your `$PATH`.

## configuration on linux

### php5

Enable PHP5 modules:

    sudo php5enmod mcrypt mysql pdo pdo_mysql


### (recommended) install composer globally

It may be useful to install composer globally:

    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod a+x /usr/local/bin/composer

### clone repository

Clone the github repository into the directory you plan to serve the files from, 
we're using `/var/www/atx/`.

HTTPS:
    
    git clone https://github.com/afeique/atx.git /var/www/atx/

SSH:

    git clone git@github.com:afeique/atx.git /var/www/atx/

### perform setup

The repository does not:

* does not track vendor libraries and packages handled by composer
* does not ship with a `.env`
* does not track permissions for cache folders

Therefore, right after cloning the source, you must setup these aspects 
yourself by running the following commands from the root folder:

    sudo composer install
    cp .env.example .env
    php artisan key:generate
    sudo chmod -R g+rw storage/

### (optional) set `/var/www` permissions

This is convenient as it allows you to work out of `/var/www` as your non-root 
user:

    sudo adduser $USER www-data
    sudo chown -R $USER:www-data /var/www{,/*}
    sudo chmod -R g+rw /var/www{,/*}

### hosts configuration 

Add the following lines to `/etc/host

    127.0.0.1   l.acrossti.me

### virtualhost configuration

Enable `mod_rewrite`:

    sudo a2enmod rewrite

Create a new configuration in `/etc/apache2/sites-available/` for symfony, 
we're  calling it `acrosstime-dev.conf`. This file will contain two virtualhost
configurations, one for the local development view, and the other for the 
local production view.

*Note:* the development view disables `.htaccess` files in the `web/` directory
whereas the production view utilizes the `.htaccess` present in the `web/`
directory.

    <VirtualHost *:80>
      ServerName l.acrossti.me
      DocumentRoot /var/www/atx/web

      <Directory /var/www/atx/web>
        DirectoryIndex index.php
        Options +Indexes +FollowSymLinks -MultiViews
        AllowOverride None
        # 2.2
        Require all granted 
        Allow from all # 2.4
        <IfModule mod_rewrite.c>
            RewriteEngine On
            #RewriteBase /path/to/app
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^ index.php [QSA,L]
        </IfModule>
      </Directory>

      ErrorLog ${APACHE_LOG_DIR}/atx.error.log
      CustomLog ${APACHE_LOG_DIR}/atx.access.log common
    </VirtualHost>

    
Enable the new site configuration:

    sudo a2ensite acrosstime-dev.conf

Restart Apache:

    sudo service apache2 restart

## setup on windows 7

### install git

[Download the msysGit installer](https://git-for-windows.github.io/). Run it.
Install to any location.


### setup ssh keys

If you plan on using git with SSH, follow Github's directions for 
[setting up SSH keys](https://help.github.com/articles/generating-ssh-keys/).

### installation of apache, php, mysql

For convenience, we will be using the [Uniform Server](http://www.uniformserver.com/).
[Download the latest version](http://sourceforge.net/projects/miniserver/files/) and
then [obtain the PHP 5.5 module](http://sourceforge.net/projects/miniserver/files/Uniform%20Server%20ZeroXI/ZeroXImodules/).

Install the Uniform Server to a location of your choosing, then copy the 
PHP 5.5 module to that directory. Run the self-extracting installer for the 
PHP module.

To ensure there are no conflicts, it is a good idea at this point to turn off
any existing web or MySQL servers you have running and listening on the default
ports.

### hosts configuration

Open the Start menu. Search for `cmd`, then right-click `cmd.exe` and run in 
Administrator mode.

At the prompt, type:

    cd %SystemRoot%\System32\drivers\etc
    notepad hosts

This will open your Windows 7 `hosts` file in notepad with administrative 
privileges. Add the following to your `hosts` file:

    127.0.0.1   l.acrossti.me

### virtualhost configuration

Go to the root folder you installed the Uniform Server to.

Open `core\apache2\httpd.conf`.

Search for the line:

    Include conf/extra/httpd-vhosts.conf

Make sure it is uncommented.

Next, open `core\apache2\conf\extra\httpd-vhosts.conf`.

Add the following virtualhost configurations:


    <VirtualHost *:{$AP_PORT}>
      ServerName l.acrossti.me
      DocumentRoot ${US_ROOTF_WWW}/atx/web

      <Directory ${US_ROOTF_WWW}/atx/web>
        DirectoryIndex index.php
        Options Indexes FollowSymLinks -MultiViews
        AllowOverride None
        Require all granted # 2.2
        Allow from all # 2.4
        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^ index.php [QSA,L]
        </IfModule>
      </Directory>

      ErrorLog ${APACHE_LOG_DIR}/acrosstime.error.log
      CustomLog ${APACHE_LOG_DIR}/acrosstime.access.log common
    </VirtualHost>


### clone repository

Open a Git Bash insie the directory the Uniform Server instance is set to
serve files from. By default, this is `www` within the root directory.

HTTPS:

    git clone https://github.com/afeique/atx.git

SSH:

    git clone git@github.com:afeique/atx.git


### start apache and mysql

Open your Uniform Server Controller and start Apache and MySQL using the buttons.
You should now be able to access the local development and testing URLs.

### (recommended) install composer

Go to the root directory of your Uniform Server install. From there, navigate to
`core\php55`. Make a note of the full path, we will refer to it as `%php_path%`.

Open a command-line. At the prompt, run:

    set PATH=%path%;%php_path%

This modifies the Windows path within the context of the command-line shell you have
open. To test your modification, run:

    php -v
    PHP 5.5.29 (cli) (built: Sep  2 2015 16:47:09)
    Copyright (c) 1997-2015 The PHP Group
    Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies

Next, download the [Composer installer for Windows](https://getcomposer.org/doc/00-intro.md#installation-windows). Install Composer, then test your Composer install:

    composer -V
    Composer version 1.0-dev (7267b2ed9063ef64e7dda86421a928a802558fdb) 2015-09-14 14:48:45

**Note: you may have to append your `%php_path%` to your system `%path%` 
every time you open a new command-line shell and wish to use Composer.**

For convenience, you can permanently add your `%php_path%` to your system 
`%path%`, or alternatively, create a specialized command-line shortcut that 
runs a `.cmd` or `.bat` file to setup variables for you. The instructions 
for doing so are omitted for now.

## linux troubleshooting

These are all actions you should take right after cloning the repository.

### failed opening required `../vendor/autoload.php`

Run from the root folder:

    sudo composer install

### no supported encrypter found

If you get the following error message:

    No supported encrypter found. The cipher and / or key length are invalid.

Run from the root folder:

    cp .env.example .env
    php artisan key:generate

### failed to open stream: permission denied
If you get the following error message:

    Failed to open stream: Permission denied

Run from the root folder:

    sudo chmod -R g+rw storage/

