FROM alpine:3.10.1

WORKDIR /backend
EXPOSE 1024

# Install base dependencies
RUN apk update && \
    apk add --no-cache supervisor python3 nginx

# Install backend requirements
COPY src/backend/requirements.txt /backend/requirements.txt

RUN apk add --no-cache gcc python3-dev musl-dev libffi-dev openssl-dev make && \
    pip3 install -r requirements.txt && \
    apk del gcc python3-dev musl-dev libffi-dev openssl-dev make

# Add configuration
ADD config /

# Copy over source
COPY build/webapp /webapp
COPY src/backend /backend

# Install full backend
RUN pip3 install .

CMD supervisord -c /etc/supervisord.conf
