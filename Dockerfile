FROM python:3.12-slim
WORKDIR /app
RUN useradd --create-home --uid 10001 --user-group app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=app:app app.py ./app.py
USER app
EXPOSE 8004
CMD ["gunicorn", "--bind", "0.0.0.0:8004", "app:app"]
