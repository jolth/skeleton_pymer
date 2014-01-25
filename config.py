# -*- coding: utf-8 -*- 
import web

# DATABASE
#web.config.db_parameters = dict(dbn="sqlite", db="sql/pymerp.db")
db = web.database(dbn="sqlite", db="sql/pymerp.db")

# DEBUG
#web.config.debug = False # descomentar en producción
