import json


TOURNAMENTS_FILE = "tournaments.json"

def load_tournaments() -> dict:
    tournaments = {}
    with open(TOURNAMENTS_FILE) as tfile:
        tournaments = json.loads(tfile.read())
    return tournaments
