import json

def test_post_get(test_client):
    new_data = {"first_name": "TEST", "last_name": "TEST", "grade": 10}

    post_response = test_client.post('/api/v1/students', data=json.dumps(new_data), content_type='application/json')
    assert post_response.status_code == 201

    get_response_data = json.loads(post_response.data)
    student_id = get_response_data['id']

    get_response = test_client.get(f'/api/v1/students/{student_id}')
    assert get_response.status_code == 200
