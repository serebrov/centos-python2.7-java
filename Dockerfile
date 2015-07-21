FROM centos:centos6
MAINTAINER Boris Serebrov

# Based on https://www.digitalocean.com/community/tutorials/how-to-set-up-python-2-7-6-and-3-3-3-on-centos-6-4

RUN yum -y update
RUN yum groupinstall -y development
RUN yum install -y zlib-dev openssl openssl-devel sqlite-devel bzip2-devel
RUN cat /var/log/yum.log

RUN yum install -y tar
RUN yum install -y git
RUN yum install -y java-1.7.0-openjdk java-1.7.0-openjdk-devel
RUN yum install -y gcc gcc-c++

# Install postgresql
# Fails, postgres service stars with [OK], but then 
# 'service postgresql status' shows 'postmaster dead but pid file exists'
# Nothing in logs as well, it looks like it just crashes
# And installation works if I log in into the container and run following commands manually
RUN yum install -y postgresql-server
RUN yum install -y postgresql-devel
# RUN service postgresql initdb
# RUN chkconfig postgresql on
# RUN service postgresql start
# RUN ls -la /var/log/
# RUN cat /var/log/lastlog
# RUN cat /var/lib/pgsql/pgstartup.log
# RUN cat /var/lib/pgsql/data/pg_log/*
# RUN ls -la /var/lib/pgsql/data/
# RUN service postgresql status
# RUN su -s /bin/sh -c "psql -h localhost -c \"ALTER USER postgres WITH PASSWORD 'root';\"" postgres
# RUN sed -ie 's/\(^host.*\)ident/\1md5/g' /var/lib/pgsql/data/pg_hba.conf
# RUN service postgresql restart

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

# Install pandas/ numpy / scipy / scikit-learn and their deps
RUN yum install -y atlas-sse3-devel lapack-devel
RUN pip install six==1.9.0
RUN pip install pandas==0.16.1
RUN pip install numpy==1.9.2
RUN pip install scipy==0.15.1
RUN pip install scikit-learn==0.16.1

RUN pip install Flask==0.10.1
RUN pip install boto==2.38.0
RUN pip install pytz==2015.4
RUN pip install py_descriptive_statistics==0.2
RUN pip install simplejson==3.6.5
RUN pip install xmltodict==0.9.2
RUN pip install markdown2==2.3.0
RUN pip install pygments==2.0.2
RUN pip install pyzmq==13.0.2
RUN pip install protobuf==2.5.0
RUN pip install protobuf-to-dict==0.1.0

RUN pip install psycopg2==2.6.1
RUN pip install SQLAlchemy==1.0.6
RUN pip install Flask-SQLAlchemy-Session==1.1
RUN pip install alembic==0.7.6
RUN pip install sqlalchemy-utils==0.30.12
