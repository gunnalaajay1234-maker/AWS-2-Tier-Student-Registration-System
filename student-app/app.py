from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from config import Config

app = Flask(__name__)
app.config.from_object(Config)     # load database settings from config.py
db  = SQLAlchemy(app)              # create database connection

# ── Student Model ─────────────────────────────────────────
# This class maps to the 'students' table in MySQL.
# SQLAlchemy will create the table automatically.
class Student(db.Model):
    __tablename__ = 'students'
    id     = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name   = db.Column(db.String(100), nullable=False)
    email  = db.Column(db.String(120), unique=True, nullable=False)
    course = db.Column(db.String(100), default='General')

    def to_dict(self):
        return {
            'id':     self.id,
            'name':   self.name,
            'email':  self.email,
            'course': self.course
        }

# ── Route 1: Home ─────────────────────────────────────────
@app.route('/')
def home():
    return jsonify({'message': 'Student Registration API is running!'})

# ── Route 2: GET all students ─────────────────────────────
@app.route('/students', methods=['GET'])
def get_all_students():
    students = Student.query.all()
    return jsonify([s.to_dict() for s in students])

# ── Route 3: POST add new student ─────────────────────────
@app.route('/students', methods=['POST'])
def add_student():
    data    = request.get_json()
    student = Student(
        name   = data['name'],
        email  = data['email'],
        course = data.get('course', 'General')
    )
    db.session.add(student)
    db.session.commit()
    return jsonify({'message': 'Student added!', 'student': student.to_dict()}), 201

# ── Route 4: GET student by ID ────────────────────────────
@app.route('/students/<int:id>', methods=['GET'])
def get_student(id):
    student = Student.query.get_or_404(id)
    return jsonify(student.to_dict())

# ── Route 5: DELETE student by ID ────────────────────────
@app.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    student = Student.query.get_or_404(id)
    db.session.delete(student)
    db.session.commit()
    return jsonify({'message': 'Student deleted successfully!'})

# ── Run the application ───────────────────────────────────
if __name__ == '__main__':
    with app.app_context():
        db.create_all()         # creates 'students' table in MySQL if it doesn't exist
    app.run(host='0.0.0.0', port=5000, debug=True)
