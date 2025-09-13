#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
cd /tmp
git clone https://github.com/Micro856/NetC.git
mkdir -p /usr/share/bootcrew/netc
cp /tmp/NetC/main.py /usr/share/bootcrew/netc/main.py
cp /tmp/NetC/netc /bin/netc
cp /tmp/NetC/bashrc /root/.bashrc
cp /tmp/NetC/bash_profile /root/.bash_profile
cd /
rm -rf /tmp/NetC
cp /ctx/os-release /etc/os-release
cp /ctx/storage.conf /etc/containers/storage.conf
chmod +x /bin/netc

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
