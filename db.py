# -*- coding: utf-8 -*-
import web
import config

def userData(**k):
    """
    """
    #return config.db.select("users", **k)[0]
    return config.db.query("SELECT * FROM users where email=$username and password=$password", **k)[0]

    
def insert_user_connections(userID):
    """
        inserta un nuevo ingreso del usuario y retorna el ID
        de la insercción.
    """
    return config.db.insert("user_connections", user=userID)
