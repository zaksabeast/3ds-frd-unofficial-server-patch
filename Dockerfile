FROM alpine as builder

WORKDIR /app

RUN apk add --no-cache git make cmake g++ && \
  git clone --recursive https://github.com/Kingcom/armips.git /app/armips && \
  mkdir /app/armips/build && \
  cd /app/armips/build && \
  cmake -DCMAKE_BUILD_TYPE=Release .. && \
  cmake --build . && \
  git clone https://github.com/Alcaro/Flips.git /app/flips && \
  cd /app/flips && \
  ./make.sh && \
  mkdir /app/bin && \
  cp /app/armips/build/armips /app/bin/. && \
  cp /app/flips/flips /app/bin/.


FROM alpine

COPY --from=builder /app/bin/* /bin/

RUN apk add --no-cache make libstdc++
