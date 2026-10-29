SECRET_KEY = 'local-classroom-only'
DEBUG = False
ALLOWED_HOSTS = ['127.0.0.1', 'localhost', '147.45.184.82']
ROOT_URLCONF = 'client.urls'
INSTALLED_APPS = []
MIDDLEWARE = ['django.middleware.csrf.CsrfViewMiddleware']
TEMPLATES = [{'BACKEND': 'django.template.backends.django.DjangoTemplates', 'DIRS': ['templates'], 'APP_DIRS': True}]
