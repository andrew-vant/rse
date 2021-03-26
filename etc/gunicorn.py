from rse.config import load

conf = load('gunicorn.yaml')

for k, v in conf.items():
    globals()[k] = v  # ew
