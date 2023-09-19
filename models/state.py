#!/usr/bin/python3
""" State Module for HBNB project """
import os

from sqlalchemy import Column, String
from sqlalchemy.orm import relationship

from models.base_model import BaseModel, Base


class State(BaseModel, Base):
    """ State class """
    __tablename__ = 'states'

    name = Column('name', String(128), nullable=False)
    cities = relationship('City', backref='state', cascade='all, delete')

    if os.getenv("HBNB_TYPE_STORAGE", None) != "db":
        @property
        def cities(self):
            return [city for city in self.cities if city.state_id == self.id]
