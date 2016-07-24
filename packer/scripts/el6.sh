sed -i '/^net.bridge.bridge-nf-call/d' /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p

yum -y install acpid
chkconfig acpid on
service acpid start

yum -y install sudo rsync

yum -y install epel-release centos-release-xen
yum -y update

yum -y install \
  autoconf \
  automake \
  bison \
  clang \
  cpp \
  curl \
  flex \
  gcc \
  gcc-c++ \
  gdb \
  git \
  glibc-devel \
  libgcrypt-devel \
  libtool \
  libtool-ltdl-devel \
  m4 \
  make \
  nc \
  pkgconfig \
  redhat-rpm-config \
  strace \
  tar \
  valgrind

yum -y install \
  ganglia-devel \
  hal-devel \
  hiredis-devel \
  iproute-devel \
  iptables-devel \
  java-1.7.0-openjdk-devel \
  java-devel \
  jpackage-utils \
  libatasmart-devel \
  libcap-devel \
  libcurl-devel \
  libdbi-devel \
  libesmtp-devel \
  libmemcached-devel \
  libmnl-devel \
  libmodbus-devel \
  libnotify-devel \
  liboping-devel \
  libpcap-devel \
  librabbitmq-devel \
  libstatgrab-devel \
  libudev-devel \
  libvirt-devel \
  libxml2-devel \
  lm_sensors-devel \
  lvm2-devel \
  mysql-devel \
  net-snmp-devel \
  nut-devel \
  OpenIPMI-devel \
  openldap-devel \
  perl-ExtUtils-Embed \
  postgresql-devel \
  protobuf-c-devel \
  python-devel \
  rrdtool-devel \
  varnish-libs-devel \
  xen-devel \
  xfsprogs-devel \
  yajl-devel

yum -y clean all

mkdir -p /opt/jenkins
ln -s /usr/lib/jvm/jre-1.7.0/bin/java /opt/jenkins/
