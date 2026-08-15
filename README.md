# QCV — Landing page

Sitio bilingüe (ES/EN) para el servicio de elaboración de CVs. Incluye
selector de idioma que se recuerda, toggle de modo claro/oscuro, y el
formulario de solicitud que guarda cada envío en Supabase.

## Estructura del sitio
- `index.html` — la landing pública: servicios, sobre mí, testimonios, y botones de "Contáctame" que abren WhatsApp directo. **No tiene formulario** — así nadie te manda información sin haber confirmado que quiere el servicio.
- `formulario.html` — página privada, sin link visible desde la landing. Se la mandas tú al cliente por WhatsApp una vez confirma que quiere avanzar. Ahí llena sus datos (nombre, experiencia, educación, certificaciones) y ese envío sí va a la tabla `cv_requests` en Supabase.

## Qué incluye
- `index.html` — todo el sitio (una sola página).
- `schema.sql` — tabla `cv_requests` (los formularios que te llegan) y
  la tabla `testimonials` (reseñas públicas, igual a CV Vault).
- `assets/` — logo, favicon e ícono, ya redimensionados para web.

## Decisión de favicon
Usé la versión con fondo cuadrado azul (imagen 5) como favicon y
apple-touch-icon, y la versión transparente (imagen 4) como ícono
decorativo dentro de la página ("Sobre mí"). Razón: un favicon se ve a
16–32px en la pestaña del navegador — el fondo sólido de la versión
cuadrada mantiene contraste y forma reconocible a ese tamaño, mientras
que la versión sin fondo puede perderse contra pestañas claras u
oscuras. La versión transparente sí funciona mejor donde ya hay un
fondo con color definido, como dentro de la tarjeta "Sobre mí".

## 1. Supabase
1. Si ya tienes el proyecto de **CV Vault**, puedes usar el mismo —
   así los testimonios se comparten entre los dos sitios. Solo corre
   la sección de `cv_requests` de `schema.sql` (la de `testimonials`
   ya existe).
2. Si es un proyecto nuevo, corre `schema.sql` completo en
   **SQL Editor**.
3. Copia `Project URL` y `anon public key` desde
   **Project Settings → API**.

## 2. Configurar `index.html`
Al final del archivo, reemplaza:
```js
const SUPABASE_URL = "https://TU-PROYECTO.supabase.co";
const SUPABASE_ANON_KEY = "TU_ANON_KEY";
const WHATSAPP_NUMBER = "18092156976"; // ya puesto con tu número
```

## 3. Desplegar (GitHub + Netlify, tu flujo habitual)
1. Sube la carpeta completa (`index.html`, `schema.sql`, `assets/`) a
   un repo de GitHub.
2. Netlify → New site from Git → selecciona el repo → Deploy.
3. Listo — Netlify sirve `index.html` como página principal
   automáticamente.

## Cómo funciona cada pieza
- **Idioma**: al entrar por primera vez, se muestra la pantalla de
  selección ES/EN. La elección se guarda en `localStorage`, así que no
  se vuelve a preguntar. El toggle "ES | EN" en la barra superior
  permite cambiarlo en cualquier momento, en cualquier sección.
- **Modo oscuro/claro**: el sitio abre en oscuro por defecto (hace
  juego con el logo). El botón de sol/luna cambia el modo y también se
  recuerda en `localStorage`.
- **Formulario**: cada experiencia laboral es un bloque repetible
  (lugar/campaña + año de entrada + año de salida). Al enviar, se
  guarda en la tabla `cv_requests` de Supabase y se abre WhatsApp con
  un mensaje inicial para que coordines el pago.
- **Testimonios**: se cargan desde la tabla `testimonials`. Si
  conectaste el mismo proyecto de CV Vault, las reseñas que dejan tus
  clientes después de desbloquear su CV aparecen aquí automáticamente.

## Revisar las solicitudes que llegan
Ve a Supabase → Table Editor → `cv_requests`. Ahí ves nombre, email,
teléfono, experiencia (en formato JSON), educación y certificaciones de
cada persona que llenó el formulario. Si quieres, más adelante podemos
agregar un panel visual tipo `admin.html` para verlos sin entrar a
Supabase directamente.

## Notas honestas
- El insert a `cv_requests` es público (cualquiera con el link puede
  enviar), pero nadie puede *leer* esos datos desde el navegador —
  solo tú, desde el dashboard de Supabase. Es el mismo patrón que
  usamos para subir los CVs en CV Vault.
- No hay validación de que el email/teléfono sean reales — es
  información que el propio cliente proporciona, igual que en un
  formulario de contacto normal.
