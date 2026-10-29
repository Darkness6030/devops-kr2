FROM golang:1.24-alpine
RUN apk add --no-cache python3 py3-pip nginx openssl protobuf curl
RUN python3 -m venv /venv
ENV PATH="/venv/bin:/go/bin:$PATH"
WORKDIR /work
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.5 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
COPY . .
RUN sh generate.sh && go mod tidy && go build -o dice-server ./server
CMD ["sh", "start.sh"]
