FROM alpine:3.12

RUN apk update
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/community/
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /etc/grafana/provisioning/dashboards
# 설치 후 service별로 dashboard 만들어서 json으로 export하여 grafana의 dashboard 폴더에 넣어주기
COPY ./dashboards /var/lib/grafana/dashboards/

COPY ./provisioning/dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards
COPY ./provisioning/datasources.yaml /usr/share/grafana/conf/provisioning/datasources

EXPOSE 3000

#start grafana
CMD /usr/sbin/grafana-server --config=/usr/share/grafana/conf/defaults.ini --homepath=/usr/share/grafana
