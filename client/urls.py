from django.urls import path
from django.http import HttpResponse
from django.shortcuts import render
from .api.client import roll_die

def index(request):
    a = b = 0
    if request.method == 'POST':
        a = roll_die('127.0.0.1:8443')
        b = roll_die('127.0.0.1:9448')
    sign = '=' if a == b else '<' if a < b else '>'
    return render(request, 'index.html', {'a': a, 'b': b, 'sign': sign})

def direct(request):
    return HttpResponse(str(roll_die('127.0.0.1:8443')))

def proxy(request):
    return HttpResponse(str(roll_die('127.0.0.1:9448')))

urlpatterns = [path('', index), path('grpc', direct), path('nginx', proxy)]
