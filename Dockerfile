FROM node:24 AS node
WORKDIR /config
COPY schemaspy/config/schemameta.yml .
RUN npx schemaspy-yml-to-xml -i schemameta.yml -o schemameta.xml

FROM schemaspy/schemaspy:6.2.4
WORKDIR /config
COPY --from=node /config/schemameta.xml /config/schemameta.xml