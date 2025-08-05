FROM python:3.12.11-slim-bullseye AS base
WORKDIR /students_app

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/
COPY migrations/ ./migrations/
COPY tests/ ./tests/
COPY config.py .
COPY run.py .
COPY students_log/ .
COPY ./entrypoint.sh .


FROM python:3.12.11-alpine
WORKDIR /students_app
COPY --from=base /opt/venv /opt/venv
COPY --from=base /students_app /students_app
RUN chmod +x ./entrypoint.sh

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 5000

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["python", "run.py"]