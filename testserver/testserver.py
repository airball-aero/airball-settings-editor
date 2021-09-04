#!/usr/bin/python

import http.server
import sys
import json

airball_settings_path = '/airball-settings.json'

airball_settings = {
    "ias_full_scale":150,
    "v_r":0,
    "v_fe":70,
    "v_no":100,
    "v_ne":120,
    "alpha_stall":17,
    "alpha_min":0,
    "alpha_x":13,
    "alpha_y":11,
    "alpha_ref":15,
    "beta_full_scale":10,
    "beta_bias":0,
    "baro_setting":30.12,
    "ball_smoothing_factor":1,
    "vsi_smoothing_factor":1,
}

class TestRequestHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == airball_settings_path:
            print('GET ' + self.path)
            self.get_airball_settings()
        else:
            self.send_error(404)

    def do_POST(self):
        if self.path == airball_settings_path:
            print('POST ' + self.path)
            self.post_airball_settings()
        else:
            self.send_error(404)

    def get_airball_settings(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(bytes(json.dumps(airball_settings) + '\n', 'utf-8'))

    def post_airball_settings(self):
        global airball_settings        
        airball_settings = json.loads(''.join([l.decode('utf-8') for l in self.rfile]))
        print(json.dumps(airball_settings))
    
http.server.HTTPServer(('', 8088), TestRequestHandler).serve_forever()
