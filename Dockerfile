# FROM rust:1.86 AS base

# WORKDIR /app

# RUN apt update
# RUN apt install -y libasound2-dev

# FROM base AS build

# COPY . .

# RUN cargo build --release

# FROM base

# COPY ./static /app/static

# COPY --from=build /app/target/release/clickrtraining /app/clickrtraining

# CMD ["./clickrtraining", "host", "--addr", "0.0.0.0", "--port", "8098"]

FROM rust:1.87-alpine AS build

WORKDIR /app
COPY . .

RUN apk add --no-cache musl-dev openssl-libs-static openssl-dev
RUN cargo build --release --no-default-features

FROM alpine

WORKDIR /app
COPY ./static /app/static
COPY --from=build /app/target/release/clickrtraining .
CMD ["./clickrtraining", "host", "--addr", "0.0.0.0", "--port", "8098"]
