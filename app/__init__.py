import os
from flask import Flask
from dotenv import load_dotenv # for setting up the env. variable instead of hard coding

from .extensions import db, migrate 
from .api.v1.routes import api_v1
from .api.v2.routes import api_v2

# separate function to create the flask application
def create_app():
    load_dotenv()
    app = Flask(__name__)

    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URI")
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)
    migrate.init_app(app, db)

    app.register_blueprint(api_v1, url_prefix='/api/v1')
    app.register_blueprint(api_v2, url_prefix='/api/v2')
    return app
