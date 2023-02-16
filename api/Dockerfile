FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

COPY . /

WORKDIR /
RUN /usr/local/bin/python -m pip install --upgrade pip
RUN pip install -r requirements.txt
COPY odbcinst.ini /etc
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]
