FROM python:3.7-alpine3.11

RUN pip install -r requirements.txt

ENV PORT=8080

CMD ["python", "main.py", "--port", "${PORT}"]
