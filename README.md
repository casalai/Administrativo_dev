# Administrativo_dev

Despliegue y operaciones

- Producción (Firebase Hosting): https://sistema-productividad-equipo.web.app
- Consola Firebase: https://console.firebase.google.com/project/sistema-productividad-equipo/overview
- GitHub Pages (alternativa): https://casalai.github.io/Administrativo_dev/

## Hosting
- La raíz `/` redirige a `esqueleto.html`.
- `index.html` hace redirect inmediato a `esqueleto.html` (respaldo para otros hostings).

## Autenticación y dominios autorizados
- La app usa Firebase Auth anónima; para que funcione desde otros dominios agrega en Firebase Console → Authentication → Settings → Authorized domains:
  - `casalai.github.io` (si usas GitHub Pages)
  - Otros dominios propios que desees usar

## Firestore Rules
- `firestore.rules` exige `request.auth != null` para todo acceso (lectura/escritura).

## Storage Rules
- `storage.rules` permite solo a usuarios autenticados leer/escribir bajo `help_requests/**`; el resto está denegado.
- Requiere activar Storage la primera vez: Firebase Console → Storage → "Comenzar".

## Despliegue manual (opcional)
- Requisitos: Node LTS + Firebase CLI.
- Comandos:
```
firebase login
firebase deploy --only hosting,firestore,storage
```

## Notas
- El dashboard tiene buscador y paginación (6 por página).
- Solicitudes de ayuda con adjuntos (imágenes/videos) y previsualización + descarga ZIP (JSZip/FileSaver).
- Autoasignación de usuario por sesión del esqueleto; sin selección manual en los módulos.
