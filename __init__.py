# Copyright 2018 Mycroft AI Inc.
# Copyright 2018 Aditya Mehra (aix.m@outlook.com).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import pyaudio
import struct
import math
import re
import sys
import json
import requests
import time

from mycroft.messagebus.message import Message
from mycroft.skills.core import MycroftSkill
from mycroft.util import connected, find_input_device
from mycroft.util.log import LOG
from mycroft.util.parse import normalize
from mycroft.audio import wait_while_speaking
from mycroft import intent_file_handler

from threading import Thread

class MycroftDesktopApplet(MycroftSkill):

    IDLE_CHECK_FREQUENCY = 6  # in seconds
    dashboard_news_items = ""
    dashboard_weather_items = ""

    def __init__(self):
        super().__init__("MycroftDesktopApplet")

        self.idle_count = 99
        self.hourglass_info = {}
        self.interaction_id = 0
        self.inputQuery = ""
        self.settings['use_listening_beep'] = True

    def initialize(self):
        try:
            # Handle changing the eye color once Mark 1 is ready to go
            # (Part of the statup sequence)
            # Handle the 'waking' visual
                        
            self.start_idle_check()

            # Handle the 'busy' visual
            self.add_event('mycroft.gui.connected', self.handle_placeholder_view)
            #self.bus.on('mycroft.skills.initialized', self.handle_display_conversation_view)
            self.gui.register_handler('mycroft.desktop.applet.show_conversationview', self.handle_display_conversation_view)
            self.gui.register_handler('mycroft.qinput.text', self.get_message_query)
    
        except Exception:
            LOG.exception('In Mycroft Applet Skill')

    #####################################################################
    # Manage "idle" visual state

    def start_idle_check(self):
        # Clear any existing checker
        print("!!!!! START IDLE CHECK !!!!!")
        self.cancel_scheduled_event('IdleCheck')
        self.idle_count = 0

        if True:
            # Schedule a check every few seconds
            self.schedule_repeating_event(self.check_for_idle, None,
                                          MycroftDesktopApplet.IDLE_CHECK_FREQUENCY,
                                          name='IdleCheck')

    def check_for_idle(self):
        print('CHECING IDLE')
        if True:
            # No activity, start to fall asleep
            self.idle_count += 1

            if self.idle_count == 5:
                # Go into a 'sleep' visual state
                #self.bus.emit(Message('mycroft-date-time.mycroftai.idle'))
                self.switch_to_dashboard_view()
            elif self.idle_count > 5:
                self.cancel_scheduled_event('IdleCheck')

    def handle_listener_started(self, message):
        if False:
            self.cancel_scheduled_event('IdleCheck')
        else:
            print("IDLE CHECK!")
            # Check if in 'idle' state and visually come to attention
            if self.idle_count > 2:
                # Perform 'waking' animation
                # TODO: Anything in QML?  E.g. self.gui.show_page("waking.qml")

                # Begin checking for the idle state again
                self.idle_count = 0
                self.start_idle_check()
                
    def get_message_query(self, message):
        self.gui['inputQuery'] = message.data['inputQuery'] 
        self.gui['state'] = 'conversation_view'
        self.gui.show_page('all.qml')
        
    def handle_placeholder_view(self):
        self.handle_dashboard_news_layer()
        self.gui['state'] = 'placeholder_view'
        self.gui['newsData'] = dashboard_news_items
        self.gui.show_page('all.qml')

    def switch_to_conversation_view(self):
        self.gui['state'] = 'conversation_view'
        self.gui['newsData'] = dashboard_news_items
        self.gui.show_page('all.qml')
    
    def switch_to_dashboard_view(self):
        self.gui['state'] = 'dashboard_view'
        self.gui['newsData'] = dashboard_news_items
        self.gui.show_page('all.qml')
        
    @intent_file_handler('show.convo.view.intent')
    def handle_display_conversation_view(self, message):
        self.gui['state'] = 'conversation_view'
        if message['inputQuery']:
            self.gui['inputQuery'] = message.data['inputQuery']
        else:
            self.gui['inputQuery'] = "" 
        self.gui.show_page('all.qml')
    
    def handle_display_dashboard_view(self, message):
        self.gui['state'] = 'dashboard_view'
        self.gui.show_page('all.qml')
    
    def handle_dashboard_news_layer(self):
        """ 
        News Ideal Screen Test Intent
        """
        getNewsLang = self.lang.split("-")
        newsLang = getNewsLang[1]
        newsAPIURL = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=a1091945307b434493258f3dd6f36698'.format(newsLang)
        newsAPIRespone = requests.get(newsAPIURL)
        newsItems = newsAPIRespone.json()
        global dashboard_news_items
        dashboard_news_items = newsItems
        
    def handle_dashboard_extras_layer(self, message):
        """
        Add PlaceHolder For Extra Items Like Timer Notifications
        """
        print("a")
        
def create_skill():
    return MycroftDesktopApplet()
