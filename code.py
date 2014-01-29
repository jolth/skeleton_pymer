# -*- coding: utf-8 -*-
"""
Copyright (c) 2013, Dev Microsystem <info@devmicrosystem.com>
All Rights Reserved.
"""
import web
import urls
import view
import config
import db

app = web.application(urls.urls, globals())

# Sessions
store = web.session.DBStore(config.db, "sessions")
session = web.session.Session(app, store, initializer={"count": 0})

# Templates
view.render._keywords["globals"]["session"] = session


# Decorador
def Session(url):
    def check(*args, **kwargs):
        """
            Decorador usado para verificar que 
            la sesión este activa.
        """
        try:
            if not session.loggedin:
                raise web.seeother('/')
        except: raise web.seeother('/')
        return url(*args, **kwargs)
    return check


class login:
    def GET(self):
        """
            Página de Login
        """
        return view.render.base(view.login(), "Login")

    def POST(self):
        """
            Comprueba si el usuario se puede logear
            y crea atributos para la sesión.
        """
        import sys

        inputData = web.input()
        
        check = config.db.query("SELECT * FROM users where email=$username and password=$password",
                vars=inputData)

        if check:
            session.loggedin = True
            # User Data:
            session.userdata = db.userData(vars=inputData) 
            # Insert table user_connections:
            insertID = db.insert_user_connections(session.userdata.id)
            #print "*"*100
            #print  
            #print "*"*100

            #print >> sys.stderr, "Login Successful"
            raise web.seeother("/dashboard")
        else:
            #print >> sys.stderr, "Login Failed"
            return view.render.base(view.login("usuario o contraseña inválida"), "Login")


class dashboard:
    @Session
    def GET(self):
        """
        """
        session.count = session.count + 1
        return view.render.base(view.dashboard(), "dashboard")

class logout:
    def GET(self):
        """
            Mata la sesión
        """
        session.kill()
        raise web.seeother("/")
        #return view.render.base(view.login(), "Login")


if __name__ == "__main__": app.run()
