export GITHUBUSERNAME="maridasi47500"
$(git clone git@github.com:$GITHUBUSERNAME/$1.git)
echo "__pycache__/\ndatabase.db" > "$1/.gitignore" 
echo "`cat <<EOF
__pycache__/
database.db
EOF`" > "$1/.gitignore" 
mkdir "$1/templates" 
mkdir "$1/static/css" -p
echo "`cat <<EOF
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>{{ the_title }}</title>

	<!-- note the special href for files in the Flask "static" folder -->
	<link rel="stylesheet" href="/static/css/main.css">

</head>
<body>

<div id="container">

  <!-- Jinja directives: page contents will go between them -->
  {% block liens %}
  {% endblock %}
  {% block content %}
  {% endblock %}

</div>

</body>
</html>
EOF`" > "$1/templates/base.html" 
echo "`cat <<EOF
{% extends 'base.html' %}

{% block content %}
<h1># $1</h1>
{% for x in users | reverse %}
 <li>{{ x["first_name"]  }}</li>

{% endfor %} 
{% endblock %}
{% block liens %}
<a href="/">welcome</a>
{% endblock %}
EOF`" > "$1/templates/hey.html" 
echo "`cat <<EOF
body {
background:black;
color:white;
}
a, a:visited, a:hover, a:link {
color:white;
}
EOF`" > "$1/static/css/main.css" 
echo "`cat <<EOF
import sqlite3
from flask import g

DATABASE = './database.db'

def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    db.row_factory = sqlite3.Row
    return db

def query_db(query, args=(), one=False):
    mydb = get_db()
    cur = mydb.execute(query, args)
    if "insert into" in query:
        mydb.commit()

    rv = cur.fetchall()
    cur.close()
    return (rv[0] if rv else None) if one else rv







EOF`" > "$1/yourappdb.py"
echo "`cat <<EOF
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
EOF`" > "$1/app.py"
echo "`cat <<EOF
CREATE TABLE  IF NOT EXISTS contacts (
	contact_id INTEGER PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	email TEXT NOT NULL UNIQUE,
	phone TEXT NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS groups (
   group_id INTEGER PRIMARY KEY,
   name TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS contact_groups(
   contact_id INTEGER,
   group_id INTEGER,
   PRIMARY KEY (contact_id, group_id),
   FOREIGN KEY (contact_id) 
      REFERENCES contacts (contact_id) 
         ON DELETE CASCADE 
         ON UPDATE NO ACTION,
   FOREIGN KEY (group_id) 
      REFERENCES groups (group_id) 
         ON DELETE CASCADE 
         ON UPDATE NO ACTION
);
INSERT OR IGNORE INTO contacts (contact_id, first_name, last_name, email, phone)
VALUES( '1', 'anonyme', 'noname', 'anonymous@email.fr', '+2653546434');
INSERT OR IGNORE INTO contacts (contact_id, first_name, last_name, email, phone)
VALUES( '2', 'anne onim', 'onim', 'anne.onim@email.com', '+86877779898');
EOF`" > "$1/schema.sql"
pwd
cp ~/list-repo/scaffold.py /home/$USER/$1
cp ~/list-repo/hellopython.sh /home/$USER/$1
cp ~/list-repo/demofile.sh /home/$USER/$1
alias proj="(cd /home/$USER/$1 && pwd)"
alias proj1="(cd /home/$USER/$1 && sh demofile.sh)"
alias proj2="(cd /home/$USER/$1 && git add .)"
alias proj3="(cd /home/$USER/$1 && git commit -am 'wow dljfghsfj')"
alias proj4="(cd /home/$USER/$1 && git push origin main)"
proj
proj1
proj2
proj3
proj4
