FROM python:3.6.4-alpine3.4

ENV PYTHONUNBUFFERED 1

RUN apk update && \
    apk add --virtual build-deps gcc python-dev musl-dev && \
    apk add postgresql-dev

RUN apk add dos2unix --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

COPY . /app

WORKDIR /app

RUN pip install --upgrade pip

RUN pip install -r requirements.txt

COPY entrypoint.sh /entrypoint.sh

RUN dos2unix entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD /usr/local/bin/gunicorn web.wsgi:application -b django:5000 --log-level=info --error-logfile=/var/log/gunicorn3.err.log
