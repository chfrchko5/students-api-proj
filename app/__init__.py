import logging
from flask import Flask, current_app, jsonify
from logging.handlers import RotatingFileHandler
from dotenv import load_dotenv # for setting up the env. variable instead of hard coding
from config import Config

from .extensions import db, migrate 
from .api.v1.routes import api_v1
from .api.v2.routes import api_v2

# separate function to set up a logger
def set_logger():
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO)

    if not root_logger.handlers:
        handler = RotatingFileHandler('students_log/students_api.log', maxBytes=10240, backupCount=5)
        log_format = logging.Formatter(
            '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
        )
        handler.setFormatter(log_format)
        root_logger.addHandler(handler)


# separate function to create the flask application
def create_app(config_object=Config):
    load_dotenv()
    app = Flask(__name__)

    # setting up logging
    if not app.debug and not app.testing:
        set_logger()

    app.config.from_object(config_object)

    db.init_app(app)
    migrate.init_app(app, db)

    app.register_blueprint(api_v1, url_prefix='/api/v1')
    app.register_blueprint(api_v2, url_prefix='/api/v2')
    
    
    @app.route('/', methods=["GET"])
    def get_index():
        current_app.logger.info("Accessed students_api root page")
        return "Root Page"
    
    @app.route('/healthcheck', methods=["GET"])
    def healthcheck():
        return jsonify({"status": "healthy"}), 200

    return app
