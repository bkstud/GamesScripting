from typing import Text, List, Any, Dict

from rasa_sdk import Tracker, FormValidationAction
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.types import DomainDict
# from rasa.nlu.utils import 


class ValidateMatchForm(FormValidationAction):
    def name(self) -> Text:
        return "validate_match_form"

    @staticmethod
    def match_db() -> List[Dict]:
        pass
    
    def validate_match(
        self,
        slot_value: Any,
        dispatcher: CollectingDispatcher,
        tracker: Tracker,
        domain: DomainDict,
    ) -> Dict[Text, Any]:
        """Validate cuisine value."""

        if any([slot_value.lower() == it.name for it in match_db]):
            # validation succeeded, set the value of the "cuisine" slot to value
            return {"match": slot_value}
        else:
            # validation failed, set this slot to None so that the
            # user will be asked for the slot again
            return {"match": None}