# Контрольная работа 2

Кирьянов Константин Николаевич, группа ЭФБО-01-24.

Проект объединяет GitHub Actions и взаимодействие Django/Python с Go через gRPC, взаимную TLS-аутентификацию и Nginx.

## Ветки и CI

- `main` — исходное состояние проекта.
- `dev` — целевая ветка интеграции.
- `feature/dice-client` — изменения для Pull Request в `dev`.

Workflow `.github/workflows/python.yml` запускается при push в `dev` и при Pull Request в `dev`. Он устанавливает Python-зависимости, проверяет синтаксис, генерирует protobuf-клиент и выполняет `python manage.py check`.

## Запуск

```sh
docker build -t kiryanov-kr2:1 .
docker run -d --name kiryanov-kr2 kiryanov-kr2:1
docker exec kiryanov-kr2 python manage.py check
docker exec kiryanov-kr2 curl -fsS http://127.0.0.1:8000/grpc
docker exec kiryanov-kr2 curl -fsS http://127.0.0.1:8000/nginx
```

Все слушатели находятся на loopback внутри контейнера. Публичные порты команда запуска не открывает. Django работает на 8000 и 8001, защищённый gRPC — 8443, Nginx с mTLS — 9448, внутренний h2c upstream — 50051.

Маршруты Django: `/` — форма броска двух кубиков, `/grpc` — прямой вызов Go, `/nginx` — вызов через Nginx. Оба RPC возвращают независимое число от 1 до 6.

## Сертификаты

`certs.sh` создаёт CA и подписывает сертификаты сервера и клиента при запуске. Приватные ключи и каталог `certs/` исключены из Git и контекста Docker. Самостоятельный учебный CA не следует использовать в промышленной среде.

## Структура

- `proto/api.proto` — контракт DiceService.
- `server/main.go` — сервер Go и журналирование RPC.
- `client/api/client.py` — Python-клиент mTLS.
- `client/urls.py` — Django-маршруты.
- `templates/index.html` — интерфейс.
- `nginx.conf` — HTTP/2, mTLS и gRPC-прокси.
- `generate.sh` — генерация Go/Python protobuf-классов.
- `Dockerfile`, `start.sh` — сборка и запуск.
