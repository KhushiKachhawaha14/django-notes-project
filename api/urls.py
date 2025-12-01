# api/urls.py

from django.urls import path

# Fix F403/F405: Import all used functions explicitly
from .views import (
    getRoutes,
    getNotes,
    updateNote,
    deleteNote,
    createNote,
    getNote
)

urlpatterns = [
    path('', getRoutes, name="routes"),
    path('notes/', getNotes, name="notes"),
    path('notes/<str:pk>/update/', updateNote, name="update-note"),
    path('notes/<str:pk>/delete/', deleteNote, name="delete-note"),
    path('notes/create/', createNote, name="create-note"),
    path('notes/<str:pk>/', getNote, name="note"),
]
