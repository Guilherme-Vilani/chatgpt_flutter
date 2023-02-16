FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17  
RUN apt-get install -y unixodbc-dev

COPY . /

WORKDIR /
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install -r requirements.txt
COPY odbcinst.ini /etc
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]
