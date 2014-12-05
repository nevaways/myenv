#!/bin/bash -x

packages=" apache2 apache2-bin apache2-data apache2-dev libapache2-mod-authnz-external libapache2-mod-passenger libapache2-mod-php5 libmagickcore5-extra php5 php5-common php5-ldap php-pear php5-cli php5-common php5-curl php5-gd php5-imagick php5-json php5-ldap php5-mysql php5-readline php5-ssh2 php5-xsl php5-ssh2 ruby-rmagick libxslt1-dev libxslt1-dbg libxml-libxslt-perl libmagickcore-dev libmagickwand-dev graphicsmagick-libmagick-dev-compat libgraphicsmagick++1-dev libaugeas-ruby libruby1.9.1 ruby ruby-augeas ruby-dev ruby-json ruby-passenger ruby-rack ruby-rmagick ruby-shadow ruby1.9.1 ruby1.9.1-dev libapache2-mod-php5 libapache2-mod-passenger libapache2-mod-authnz-external"

#/usr/bin/gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
#/usr/bin/wget -v http://mirrors.kernel.org/ubuntu/pool/universe/p/php-imagick/php5-imagick_3.1.2-1build1_amd64.deb
#/usr/bin/dpkg -i php5-imagick_3.1.2-1.1_amd64.deb

####
#ruby crap
####

#curl -sSL https://get.rvm.io | bash -s stable --ruby
#rvm install ruby-1.9.3-p551
#rvm alias create default ruby-1.9.3-p551

/usr/bin/apt-get update

#########
#Teardown
#########

function teardown() {
    /usr/bin/apt-get remove rubygems
    /usr/bin/apt-get remove --purge `dpkg -l | grep php | grep -w 5.4 | awk '{print $2}' | xargs`
    for p in $package ; do dpkg --purge $p ; done
}

########
#Buildup
########

function buildup() {
    for p in $packages ; do apt-get -y install $p ; done
    #/usr/sbin/php5enmod imagick
}
