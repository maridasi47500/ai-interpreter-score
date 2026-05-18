from flask import Flask, render_template, request
from yourappdb import query_db, get_db
from flask import g

app = Flask(__name__)
def init_db():
    with app.app_context():
        db = get_db()
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()
init_db()

@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()

@app.route("/")
def hello_world():
    user = query_db('select * from contacts')
    the_username = "anonyme"
    one_user = query_db('select * from contacts where first_name = ?',
                [the_username], one=True)
    return render_template("hey.html", users=user, one_user=one_user, the_title="my title")
@app.route("/add_one_job", methods=["GET","POST"])
def add_one_job():

    if request.method == 'POST':

        the_username = "anonyme"
        one_user = query_db("insert into job (name,description) values (:name,:description)",request.form)
        user = query_db('select * from job')
        return render_template("jobform.html", jobs=user, one_user=one_user, the_title="add new job")
    user = query_db('select * from job')
    one_user = query_db("select * from job limit 1", one=True)
    return render_template("jobform.html", jobs=user, one_user=one_user, the_title="add new job")

@app.route("/add_one_places", methods=["GET","POST"])
def add_one_places():

    if request.method == 'POST':

        the_username = "anonyme"
        one_user = query_db("insert into places (name,lat,lon,) values (:name,:lat,:lon,:)",request.form)
        user = query_db('select * from places')
        return render_template("placesform.html", placess=user, one_user=one_user, the_title="add new places")
    user = query_db('select * from places')
    one_user = query_db("select * from places limit 1", one=True)
    return render_template("placesform.html", placess=user, one_user=one_user, the_title="add new places")

@app.route("/add_one_user", methods=["GET","POST"])
def add_one_user():

    if request.method == 'POST':

        the_username = "anonyme"
        one_user = query_db("insert into user (username,email,password,phone,country_id,job_id) values (:username,:email,:password,:phone,:country_id,:job_id)",request.form)
        user = query_db('select * from user')
        return render_template("userform.html", users=user, one_user=one_user, the_title="add new user")
    user = query_db('select * from user')
    one_user = query_db("select * from user limit 1", one=True)
    return render_template("userform.html", users=user, one_user=one_user, the_title="add new user")

@app.route("/add_one_fakecommunication", methods=["GET","POST"])
def add_one_fakecommunication():

    if request.method == 'POST':

        the_username = "anonyme"
        one_user = query_db("insert into fakecommunication (com_type,content,description) values (:com_type,:content,:description)",request.form)
        user = query_db('select * from fakecommunication')
        return render_template("fakecommunicationform.html", fakecommunications=user, one_user=one_user, the_title="add new fakecommunication")
    user = query_db('select * from fakecommunication')
    one_user = query_db("select * from fakecommunication limit 1", one=True)
    return render_template("fakecommunicationform.html", fakecommunications=user, one_user=one_user, the_title="add new fakecommunication")

