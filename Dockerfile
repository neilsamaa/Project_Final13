# Gunakan image NGINX sebagai base
FROM nginx:alpine

# Hapus default konten NGINX
RUN rm -rf /usr/share/nginx/html/*

# Salin seluruh file HTML dan aset ke direktori web nginx
COPY . /usr/share/nginx/html

# Port default
EXPOSE 80
