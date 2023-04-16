# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

from typing import Any, Text, Dict, List

from rasa_sdk import Tracker
from rasa_sdk.interfaces import Action
from rasa_sdk.executor import CollectingDispatcher
import json
import yaml

class ActionListMatches(Action):

    def name(self) -> Text:
        return "action_list_matches"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        
        msg = "No information about current tournaments."
        tournaments = {}
        try:
            with open("tournaments.json") as tfile:
                tournaments = json.loads(tfile.read())

        except Exception as e:
            print(e)
        
        def parse_tournament(t):
            return yaml.dump({k.capitalize(): v for k, v in t.items()}, sort_keys=False)
        
        if tournaments:
            msg = "Here is a list of available tournaments:\n\n"
            msg += "-" * 30 + "\n"
            msg += ("\n"+ "-" * 30 + "\n").join([parse_tournament(t) for t in tournaments])
            msg += "-" * 30 + "\n"
            
        dispatcher.utter_message(text=msg)

        return []
