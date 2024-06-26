FROM python:alpine

RUN apk --update add postgresql-client

WORKDIR /usr/src/app

COPY ./files/requirements.txt .
RUN pip install -r requirements.txt

COPY ./files/rest.py .
ENV FLASK_APP ./rest.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_RUN_PORT 8080
EXPOSE 8080
EXPOSE 5432

CMD [ "flask", "run"]