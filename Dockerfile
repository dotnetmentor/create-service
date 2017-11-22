FROM bash:4.3.48

WORKDIR ./create-service

ADD ./ ./

RUN apk update \
    && apk add jq=1.5-r3 \
    && apk add curl \
    && apk add git

RUN git config --global user.email "create-service@github.com" \
    && git config --global user.name "create-service (https://github.com/dotnetmentor/create-service)"

RUN [ -f ./config.json ] || echo '{}' > ./config.json

ENTRYPOINT ["./create-service"]
