# gtfs-jp-db

https://www.mlit.go.jp/sogoseisaku/transport/sosei_transport_tk_000067.html

```
docker compose build
docker compose up -d db
docker compose up schemaspy
docker compose exec db bash -c 'psql -d gtfs_jp -U postgres'
```
