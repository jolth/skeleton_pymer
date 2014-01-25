# -*- coding: utf-8 -*-
import web
import db

#render = web.template.render("templates/")
render = web.template.render("templates/", globals={"company": "Dev Microsystem S.A.S"})


# 
#def dashboard(**k):
#    l = db.userData(**k)
#    return render.dashboard(l)

def dashboard():
    return render.dashboard()
