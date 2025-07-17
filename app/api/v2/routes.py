from flask import Blueprint, jsonify, request, current_app
from app.extensions import db
from app.model import Student

api_v2 = Blueprint('v2', __name__)

@api_v2.route("/students", methods=["GET"])
def get_students():
    students = Student.query.all()
    result = [
        {
            "id": student.id,
            "first_name": student.first_name,
            "last_name": student.last_name,
            "grade": student.grade,
            "zipcode": student.zipcode
        } for student in students
    ]

    current_app.logger.info('v2 API students table was reached')
    return jsonify(result), 200


@api_v2.route("/students/<int:student_id>", methods=["GET"])
def get_student(student_id):
    student = Student.query.get_or_404(student_id)
    current_app.logger.info(f'v2 API student id {student_id} was reached')
    return jsonify(student.to_dict_v1()), 200


@api_v2.route("/students", methods=["POST"])
def add_student():
    data = request.get_json()

    new_student = Student(
        first_name=data["first_name"],
        last_name=data["last_name"],
        grade=data["grade"],
        zipcode=data["zipcode"]
        )
                          
    db.session.add(new_student)
    db.session.commit()

    return jsonify(new_student.to_dict_v1()), 201


@api_v2.route("/students/<int:student_id>", methods=["PUT"])
def update_student(student_id):
    data = request.get_json()

    student = Student.query.get_or_404(student_id)
    if student:
        student.first_name = data.get("first_name", student.first_name)
        student.last_name = data.get("last_name", student.last_name)
        student.grade = data.get("grade", student.grade)
        student.zipcode = data.get("zipcode", student.zipcode)

        db.session.commit()
        return jsonify(student.to_dict_v1()), 202
    

@api_v2.route("/students/<int:student_id>", methods=["PATCH"])
def patch_student(student_id):
    student = Student.query.get_or_404(student_id)
    data = request.get_json()
    
    for key, value in data.items():
        setattr(student, key, value)

    db.session.commit()
    return jsonify(student.to_dict_v1()), 202


@api_v2.route("/students/<int:student_id>", methods=["DELETE"])
def delete_student(student_id):
    student = Student.query.get_or_404(student_id)
    if student:
        db.session.delete(student)
        db.session.commit()

        return jsonify({"message: student deleted "}), 202