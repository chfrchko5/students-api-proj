import json
from app.model import Student

def test_post(test_client):
    new_data = {"first_name": "TEST", "last_name": "TEST", "grade": 10}

    response = test_client.post('/api/v1/students', data=json.dumps(new_data), content_type='application/json')
    assert response.status_code == 201