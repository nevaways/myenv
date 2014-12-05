#!/bin/bash

# bring some color to my screen
red='\033[0;31m'

packages="
apache2
apache2-bin
apache2-data
apache2-dev
libapache2-mod-authnz-external
libapache2-mod-passenger
libapache2-mod-php5
libmagickcore5-extra
php5
php5-common
php5-ldap
php-pear
php5-cli
php5-common
php5-curl
php5-gd
php5-imagick
php5-json
php5-ldap
php5-mysql
php5-readline
php5-ssh2
php5-xsl
php5-ssh2
ruby-rmagick
libxslt1-dev
libxslt1-dbg
libxml-libxslt-perl
libmagickcore-dev
libmagickwand-dev
graphicsmagick-libmagick-dev-compat
libgraphicsmagick++1-dev
libaugeas-ruby
libruby1.9.1
ruby
ruby-augeas
ruby-dev
ruby-json
ruby-passenger
ruby-rack
ruby-rmagick
ruby-shadow
ruby1.9.1
ruby1.9.1-dev
libapache2-mod-php5
libapache2-mod-passenger
libapache2-mod-authnz-external"

#########
#Teardown
#########

teardown() {
    echo "executing teardown"
    echo "killing $p"
    for p in $package ; do echo "killing $p" && apt-get remove -y $p && dpkg --purge $p && dpkg --remove $p ; done

    gem remove rmagick
    gem remove bundler
    gem remove bundler-unload
    gem remove gem-wrappers
    gem remove io-console
    gem remove json
    gem remove rake
    gem remove rdoc
    gem remove rubygems-bundler

    gem remove rvm
    rvm implode --force
}

########
#Buildup
########

buildup () {

    echo "building up legacy"
    /usr/bin/apt-get update

    for p in $packages ; do echo -e "${red}installing $p" && apt-get install -y $p; done ;

    curl -sSL https://get.rvm.io | bash -s stable --ruby
    rvm install ruby-1.9.3-p551
    rvm alias create default ruby-1.9.3-p551
    rvm use ruby-1.9.3-p551
    gem install rmagick -v '2.13.2'
    gem install bundler
    gem install bundler-unload
    gem install gem-wrappers
    gem install io-console
    gem install json
    gem install rake
    gem install rdoc
    gem install rubygems-bundler

    if [ -a /usr/lib/php5/20121212/imagick.so ]; then
        /usr/sbin/php5enmod imagick
    else
       /us/bin/apt-get install php5-imagick && /usr/sbin/php5enmod imagick
    fi

    if  grep -Fxq rvm /home/jenkins/.bashrc ; then
        echo "rvm already in path"
    else
        echo "adding rvm to jenkkins path"
        echo "export PATH=\"$PATH:/usr/local/rvm/bin:\$HOME/.rvm/scripts/rvm\"" >> ~jenkins/.bashrc
    fi

    if [ !-d /System/Library/ColorSync/Profiles/  ]; then
        /bin/mkdir -p /System/Library/ColorSync/Profiles
        /bin/cp -v ./"sRGB Profile.icc" /System/Library/ColorSync/Profiles/
    fi
}

while getopts cbh opt
do
    case "$opt" in
        c) teardown ; exit 0  ;;
        b) buildup ; exit 0  ;;
        *) echo "specify -c for clean or -b for build " ; exit 0 ;;
    esac
done



