from app import create_app
from prometheus_flask_exporter import PrometheusMetrics

# set up flask app
app = create_app()
metrics = PrometheusMetrics(app)
metrics.start_http_server(port=5001)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)