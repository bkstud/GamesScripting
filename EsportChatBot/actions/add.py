# This files contains your custom actions which can be used to run
# custom Python code.
#
# See this guide on how to implement these action:
# https://rasa.com/docs/rasa/custom-actions


# This is a simple example for a custom action which utters "Hello World!"

import json
from typing import Any, Dict, List, Text

import yaml
from rasa_sdk import Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.interfaces import Action
from rasa_sdk.events import SlotSet
from rasa.nlu.utils import write_json_to_file
from .tournaments import load_tournaments
import random


class ActionRegisterPlayer(Action):

    def name(self) -> Text:
        return "action_register_player"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        tournaments = {}
        try:
            tournaments = load_tournaments()
        except Exception as e:
            print(e)

        cur_values = tracker.current_slot_values()
        choosen_tournament = cur_values['match_name']
        player = cur_values['player_name']

        t = [t for t in tournaments if t.get("name").lower() == choosen_tournament.lower()]
        if not t:
            msg = f"There is no tournament with name {choosen_tournament} please list tournaments and register again."
        else:
            tournament = t[0]
            teams = tournament['registered']
            teamSize = tournament['team size']
            non_full_teams = [name for name, team in teams.items() if len(team) < teamSize]
            user_registered = [player in team for team in teams.values()]
            if any(user_registered):
                msg = "You are already registered for this tournament try registering for different one."
            elif not non_full_teams:
                msg = "I am sorry there is no place in teams try to register later or to other tournament."
            else:
                random_team = random.choice(non_full_teams)
                msg = f"Successfully registered player '{player}' to tournament '{choosen_tournament}'."
                msg += f"\nYour team is team '{random_team}' list match details to see your team members and oponents."
                print(tournament['registered'].get(random_team))
                tournament['registered'][random_team].append(player)
                print(tournament['registered'][random_team])
                write_json_to_file("tournaments.json", tournaments)
        
        dispatcher.utter_message(text=msg)
        return [SlotSet("player_name", None), SlotSet("match_name", None)]
