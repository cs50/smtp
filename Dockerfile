FROM ubuntu:14.04
EXPOSE 587
ENV TERM xterm

# install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates postfix sasl2-bin

# configure saslauthd
RUN sed -i 's#^START\s*=.*$#START=yes#' /etc/default/saslauthd && \
    sed -i 's#^MECHANISMS\s*=.*$#MECHANISMS="sasldb"#' /etc/default/saslauthd && \
    sed -i 's#^OPTIONS\s*=.*$#OPTIONS="-c -m /var/spool/postfix/var/run/saslauthd"#' /etc/default/saslauthd

# configure postfix
RUN echo "allow_plaintext: true" > /etc/postfix/sasl/smtpd.conf && \
    echo "mech_list: PLAIN LOGIN" >> /etc/postfix/sasl/smtpd.conf && \
    echo "pwcheck_method: saslauthd" >> /etc/postfix/sasl/smtpd.conf && \
    postconf -e "smtp_sasl_auth_enable = yes" && \
    postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" && \
    postconf -e "smtp_sasl_security_options = noanonymous" && \
    postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" && \
    postconf -e "smtp_tls_security_level = may" && \
    postconf -e "smtp_use_tls = yes" && \
    postconf -e "smtpd_relay_restrictions = permit_sasl_authenticated reject" && \
    postconf -e "smtpd_sasl_auth_enable = yes" && \
    postconf -e "smtpd_sasl_security_options = noanonymous" && \
    postconf -e "smtpd_sasl_path = smtpd" && \
    postconf -e "smtpd_tls_cert_file = /etc/ssl/certs/ssl-cert-snakeoil.pem" && \
    postconf -e "smtpd_tls_key_file = /etc/ssl/private/ssl-cert-snakeoil.key" && \
    postconf -e "smtpd_use_tls = yes" && \
    sed -i -r 's/^(smtp\s+inet\s+)/#\1/' /etc/postfix/master.cf && \
    sed -i -r 's/^#\s*(submission\s+inet\s+)/\1/' /etc/postfix/master.cf && \
    usermod -a -G sasl postfix

# configure, start server
CMD echo [${SMTP_HOST}]:${SMTP_PORT} ${SMTP_USERNAME}:${SMTP_PASSWORD} > /etc/postfix/sasl_passwd && \
    postmap /etc/postfix/sasl_passwd && \
    postconf -e "relayhost = [${SMTP_HOST}]:${SMTP_PORT}" && \
    service saslauthd start && \
    echo "${SMTP_PASSWORD}" | saslpasswd2 -c "${SMTP_USERNAME}" -p && \
    service rsyslog start && \
    service postfix start && \
    sleep infinity
