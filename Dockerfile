FROM continuumio/miniconda3:latest

ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

RUN mkdir /app
WORKDIR /app


RUN apt-get update -yqq \
   && apt-get install apt-utils -yqq \
   && apt-get install freetds-bin -yqq \
   && apt-get install build-essential -yqq \
   && apt-get install sudo -yqq \
   && apt-get install apache2 -yqq \
   && apt-get install apache2-utils -yqq \
   && apt-get install vim -yqq \
   && apt-get install net-tools -yqq \
   && apt-get install python-dev -yqq \
   && apt-get install libpq-dev -yqq \
   && apt-get autoremove -yqq --purge \
   && apt-get clean \
   && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
   
RUN pip install -U pip setuptools wheel \
    && pip install pytz \
    && pip install pyOpenSSL \
    && pip install pyasn1 \
    && pip install psycopg2 \
    && pip install mlflow \
    && pip install psycopg2


ADD apache2.conf /etc/apache2/apache2.conf

RUN ln -sf /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/socache_shmcb.conf /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/ldap.load /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/ldap.conf /etc/apache2/mods-enabled
RUN ln -sf /etc/apache2/mods-available/authnz_ldap.load /etc/apache2/mods-enabled

ADD entrypoint.sh ./entrypoint.sh

# ADD cert/certificate.cert /cert/certificate.cert
# ADD cert/certificate.key  /cert/certificate.key
ADD ldap_ca.crt /etc/ca/ldap_ca.crt


RUN useradd -u 1002 mlflow
RUN usermod -aG sudo mlflow

RUN echo "mlflow ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN chown -R mlflow:mlflow /app


RUN chmod +x ./entrypoint.sh

USER mlflow

ENTRYPOINT [ "/app/entrypoint.sh" ]
#CMD [ "/app/entrypoint.sh" ]
