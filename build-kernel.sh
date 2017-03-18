KERNEL="4.9.14"
MAINTAINER_NAME="Aydin Yakar"
MAINTAINER_MAIL="aydin@komutan.org"
REVISION="1.0~komutan"
CPU="16" # CPU to be used for kernel building

if [ "$(id -u)" != "0" ]; then echo "Must be root"; exit 1; fi

apt-get install fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package

# gpg2 key
[[ ! $(gpg2 --list-keys | grep -w 6092693E) ]] && gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 38DBBDC86092693E


# download kernel
if [ ! -f linux-$KERNEL.tar ]; then
        [[ ! -f linux-$KERNEL.tar.xz ]]   && wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL.tar.xz
        [[ ! -f linux-$KERNEL.tar.sign ]] && wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL.tar.sign
        [[ -f linux-$KERNEL.tar.xz ]]   && unxz linux-$KERNEL.tar.xz
fi


# kernel src verify
if [ -f linux-$KERNEL.tar ]; then
        #verify kernel.tar
        gpg2 --verify linux-$KERNEL.tar.sign
        if [ $? != 0 ]; then echo "GPG Key cant verify.."; exit 1; fi
fi


# untar if kernel folder not exist
[[ ! -d linux-$KERNEL ]] && tar xf linux-$KERNEL.tar
cd linux-$KERNEL


# kernel config for Komutan Linux based Debian Jessie
[[ ! -f .config ]] && wget -O .config https://raw.githubusercontent.com/komutanlinux/kernel/master/config 


# maintainer and email for deb package
sed -i "s/maintainer := .*/maintainer := $MAINTAINER_NAME/g" /etc/kernel-pkg.conf
sed -i "s/email := .*/email := $MAINTAINER_MAIL/g" /etc/kernel-pkg.conf

# make
make-kpkg clean
fakeroot make-kpkg --initrd --revision=$REVISION kernel_image kernel_headers -j $CPU
