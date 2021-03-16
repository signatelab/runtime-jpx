FROM continuumio/anaconda3:2019.03

ENV PYTHONUNBUFFERED=TRUE \
    PYTHONDONTWRITEBYTECODE=TRUE \
    TZ="Asia/Tokyo" \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:en

RUN apt-get -y update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libmecab-dev \
    locales \
    mecab \
    mecab-ipadic-utf8 \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    locale-gen ja_JP.UTF-8

RUN mkdir -p /usr/lib/x86_64-linux-gnu/mecab/dic && \
    cd /usr/local/src && \
    git clone https://github.com/neologd/mecab-ipadic-neologd.git --branch v0.0.7 --single-branch && \
    cd mecab-ipadic-neologd && \
    bin/install-mecab-ipadic-neologd -y && \
    rm -rf /usr/local/src/mecab-ipadic-neologd

COPY requirements.txt /root
RUN pip install -U pip && \
    pip install -r /root/requirements.txt && \
    rm -f /root/requirements.txt

RUN conda update conda && \
    conda install -c conda-forge ta-lib

WORKDIR /opt/ml
RUN useradd signate -u 1000 -s /bin/bash -m
USER signate

COPY download_models.py /tmp/download_models.py
RUN python /tmp/download_models.py
