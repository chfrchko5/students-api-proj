import pytest
from app import create_app
from app.extensions import db
from config import TestingConfig

@pytest.fixture(scope='module')
def test_app():
    app = create_app(config_object=TestingConfig)

    with app.app_context():
        db.create_all()
        yield app
        
        db.session.remove()
        db.drop_all()

@pytest.fixture(scope='module')
def test_client(test_app):
    return test_app.test_client()