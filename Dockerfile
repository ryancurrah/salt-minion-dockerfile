FROM centos:7

MAINTAINER Ryan Currah

ENV container docker

RUN yum -y update; yum clean all

RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y sudo

RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

RUN yum install -y curl

RUN yum install -y git

RUN yum install -y ruby

RUN curl -o "/tmp/get-pip.py" "https://bootstrap.pypa.io/get-pip.py"; python /tmp/get-pip.py; rm -rf /tmp/get-pip.py

RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-2015.8-2.el7.noarch.rpm

RUN yum install -y salt-minion

RUN yum install -y epel-release

RUN yum install -y cabal-dev

RUN cabal update

RUN cabal install process-1.1.0.2 cabal --force-reinstalls

RUN cabal install shellcheck

RUN pip install flake8

VOLUME ['/sys/fs/cgroup']

CMD ['/usr/sbin/init']
