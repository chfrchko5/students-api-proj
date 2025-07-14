from .extensions import db

class Student(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(50), nullable=False)
    last_name = db.Column(db.String(50), nullable=False)
    grade = db.Column(db.Integer, nullable=False)
    zipcode = db.Column(db.Integer)

    def to_dict_v1(self):
        return {
            "id": self.id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "grade": self.grade
        }
    
    def to_dict_v2(self):
        return {
            "id": self.id,
            "first_name": self.first_name,
            "last_name": self.last_name,
            "grade": self.grade,
            "zipcode": self.zipcode
        }

    def __repr__(self):
        return f"Student {self.first_name} {self.last_name} in grade {self.grade}"
    
    