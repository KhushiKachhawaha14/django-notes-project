FROM python:3.9

Set environment variables for non-interactive commands

ENV DEBIAN_FRONTEND=noninteractive

Set the working directory

WORKDIR /app/backend

Copy requirements before installing dependencies (for better layer caching)

COPY requirements.txt /app/backend/

Install system dependencies needed for mysqlclient

RUN apt-get update 

&& apt-get upgrade -y 

&& apt-get install -y gcc default-libmysqlclient-dev pkg-config 

&& rm -rf /var/lib/apt/lists/*

Install Python dependencies (including gunicorn)

RUN pip install --no-cache-dir -r requirements.txt

Copy the rest of the application code

COPY . /app/backend/

Expose the port the application will run on

EXPOSE 8000

*** CRITICAL FIX: The command that runs when the container starts ***

This command MUST run a long-running foreground process (Gunicorn)

It is also common to run migrations before starting the server.

NOTE: Replace 'notesapp' with the name of your main Django project directory

CMD sh -c "python manage.py makemigrations && python manage.py migrate && gunicorn --bind 0.0.0.0:8000 notesapp.wsgi:application"
