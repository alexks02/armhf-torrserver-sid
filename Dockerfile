FROM arm32v7/debian:stable

COPY bin/ /usr/bin/
RUN [ "cross-build-start" ]

ENV GO /usr/lib/go-1.10/bin/go
ENV WORK /tmp/TorrServer
ENV GOBIN /usr/lib/go-1.10/bin
ENV OUT dist/TorrServer

RUN	echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list && \
	apt-get update && apt-get install -y git golang-1.10-go && \
	cd /tmp && \
	git clone https://github.com/YouROK/TorrServer.git && \
	cd $WORK && \
	GOPATH=$WORK GOBIN=$GOBIN $GO get ./... && \
	cd $WORK/src/github.com/anacrolix && \
	git clone https://github.com/anacrolix/utp.git && \
	cd $WORK && \
	GOPATH=$WORK GOARM=7 GOOS=linux GOARCH=arm $GO build -o $OUT main && \
	mv $OUT / && \
	apt-get purge --auto-remove -y git golang-1.10.go && \
	rm -rf /var/lib/apt $WORK

EXPOSE 8090:8090
CMD ["/TorrServer"]
