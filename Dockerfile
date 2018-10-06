FROM httpd:2.4.35
ADD kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN \
  apt-get update &&\
  apt-get -y install yum-utils createrepo curl &&\
  touch /etc/yum.conf &&\
  mkdir -p /var/lib/reposync/kubernetes/yum &&\
  reposync --newest-only -r kubernetes  -p /var/lib/reposync/kubernetes/yum &&\
  rmdir /var/lib/reposync/kubernetes/yum/kubernetes &&\
  rmdir /var/lib/reposync/kubernetes/yum &&\
  mkdir -p /usr/local/apache2/htdocs/yum/repos &&\
  mkdir -p /usr/local/apache2/htdocs/yum/doc &&\
  createrepo /var/lib/reposync/kubernetes &&\
  cd /usr/local/apache2/htdocs/yum/doc &&\
  curl -O -L https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg &&\
  ln -s /var/lib/reposync/kubernetes /usr/local/apache2/htdocs/yum/repos/kubernetes-el7-x86_64 &&\
  rm /usr/local/apache2/htdocs/index.html &&\
  rm /etc/yum.conf &&\
  apt-get -y remove yum-utils createrepo curl &&\
  apt-get -y autoremove &&\
  rm -rf /var/lib/apt/lists/*
