FROM ubuntu:latest
RUN apt update && apt install git -y && apt install python3-pip -y
RUN apt install libgeos-dev -y
RUN git clone https://github.com/yuasosnin/russian-empire-migrations
WORKDIR /russian-empire-migrations
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
ENV DASH_DEBUG_MODE False
EXPOSE 8050
CMD python3 app.py