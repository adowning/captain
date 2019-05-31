FROM elicocorp/odoo:12.0
MAINTAINER Elico Corp <webmaster@elico-corp.com>
RUN pip3 install --upgrade cffi
RUN pip3 install captcha simple-crypt recaptcha-client
RUN pip3 install --upgrade pillow