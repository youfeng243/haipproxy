#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2018/7/23 18:42
# @Author  : youfeng
import time

from flask import Flask, jsonify

from haipproxy.client.py_cli import ProxyFetcher
from haipproxy.config.settings import REDIS_HOST, REDIS_PORT, REDIS_PASSWORD, REDIS_DB
from logger import Applogger

global_logger = Applogger('proxy_server.log')
log = global_logger.get_logger()

app = Flask(__name__)

args = dict(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD, db=REDIS_DB)
fetcher = ProxyFetcher('http', strategy='robin', redis_args=args)


@app.route('/')
def index():
    return "proxy server is working!"


@app.route("/proxy/num")
def proxy_num():
    proxies_num = fetcher.get_proxies_num()
    return jsonify(proxies_num)


@app.route("/proxy/list")
def proxy_list():
    proxies_list = fetcher.get_proxies_list()
    return jsonify(proxies_list)


@app.route('/proxy/ip', methods=['GET'])
def get_proxy():
    start_time = time.time()
    proxy = fetcher.get_proxy()
    fetcher.proxy_feedback("failure", proxy)
    log.info("当前获取代理: {} 耗时: {} s".format(proxy, time.time() - start_time))
    return proxy


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9400)
