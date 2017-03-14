# kernel config

# How to Build (It was built like this but not tested)
. sudo apt-get install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc
.
. sudo apt-get install kernel-package

gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 38DBBDC86092693E

wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.14.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.14.tar.sign

unxz linux-4.9.14.tar.xz
gpg2 --verify linux-4.9.14.tar

tar xvf linux-4.9.14.tar
cd linux-4.9.14/
cp -v /boot/config-$(uname -r) .config
#make menuconfig
make-kpkg clean
fakeroot make-kpkg --initrd --revision=1.0.NAS kernel_image kernel_headers -j 16 #16 core
