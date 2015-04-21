FROM centos:centos6
MAINTAINER Boris Serebrov

# Based on https://www.digitalocean.com/community/tutorials/how-to-set-up-python-2-7-6-and-3-3-3-on-centos-6-4

RUN yum -y update
RUN yum groupinstall -y development
RUN yum install -y zlib-dev openssl openssl-devel sqlite-devel bzip2-devel

RUN yum install -y tar
RUN yum install -y git
RUN yum install -y java-1.7.0-openjdk java-1.7.0-openjdk-devel
RUN yum install -y gcc gcc-c++

# Install python 2.7.6
WORKDIR /tmp
ADD https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz /tmp/
RUN tar -xvzf Python-2.7.6.tgz
WORKDIR /tmp/Python-2.7.6
RUN ./configure --prefix=/usr/local
RUN make
RUN make altinstall

# create a symlink python -> python2.7
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python

# Install setuptools
WORKDIR /tmp
ADD https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz /tmp/
RUN tar -xvzf setuptools-1.4.2.tar.gz
WORKDIR /tmp/setuptools-1.4.2
RUN python2.7 setup.py install
# Install pip and virtualenv
RUN curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -
RUN pip install virtualenv
