# Password Generator

A React + Vite password generator app.

## React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Oxc](https://oxc.rs)
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/)

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and [`typescript-eslint`](https://typescript-eslint.io) in your project.

## Running Locally

```bash
npm install
npm run dev
```

## Deployment with Docker

The app is containerized using a multi-stage Dockerfile: it builds the static site with Node.js, then serves the output with Nginx (`-alpine-slim` image) over HTTPS. Plain HTTP requests are redirected to HTTPS.

### 1. Provide a TLS certificate

Nginx expects `certs/server.crt` and `certs/server.key` (mounted into the container at `/etc/nginx/certs`).

For local development/testing, generate a self-signed certificate:

```bash
./scripts/generate-self-signed-cert.sh
```

For production, replace `certs/server.crt` / `certs/server.key` with a certificate from a real CA (e.g. Let's Encrypt) or mount them from your secrets manager. The `certs/` directory is git-ignored and never baked into the image.

### 2. Build and run with Docker

```bash
docker build -t password-generator .
docker run -d \
  -p 8080:80 -p 8443:443 \
  -v "$(pwd)/certs:/etc/nginx/certs:ro" \
  --name password-generator password-generator
```

The app will be available at [https://localhost:8443](https://localhost:8443) (HTTP on 8080 redirects to HTTPS). Since the dev cert is self-signed, your browser will show a trust warning — this is expected.

### 3. Build and run with Docker Compose

```bash
docker compose up -d --build
```

This starts the app on [https://localhost:8443](https://localhost:8443) with HTTP on `8080` redirecting to HTTPS. To stop it:

```bash
docker compose down
```

> Note: the redirect targets standard port 443 (`https://$host$request_uri`). If you publish HTTPS on a non-standard host port (like `8443` above), navigate to `https://localhost:8443` directly instead of following the redirect from port `8080`. In production, publish `80`/`443` directly (or terminate TLS at a load balancer) so the redirect works as expected.

### Deploying to a server / cloud

1. Push the image to a container registry (Docker Hub, GHCR, ECR, etc.):
   ```bash
   docker build -t <registry>/<username>/password-generator:latest .
   docker push <registry>/<username>/password-generator:latest
   ```
2. On the target host, pull and run the image (or use `docker-compose.yml` with the `image` field pointing to the registry):
   ```bash
   docker pull <registry>/<username>/password-generator:latest
   docker run -d -p 80:80 --name password-generator <registry>/<username>/password-generator:latest
   ```
3. For platforms like AWS ECS/Fargate, Azure Container Apps, Google Cloud Run, or Kubernetes, deploy the same image and expose container port `80` behind your load balancer/ingress.

### Files

- `Dockerfile` – multi-stage build (Node build stage + `nginx:alpine-slim` runtime stage) for a minimal image
- `nginx.conf` – HTTP→HTTPS redirect, TLS termination (TLSv1.2/1.3), SPA fallback routing, and static asset caching
- `docker-compose.yml` – local orchestration, maps host ports `8080`/`8443` to container `80`/`443` and mounts `./certs`
- `scripts/generate-self-signed-cert.sh` – generates a local dev TLS certificate/key into `certs/`
- `.dockerignore` – excludes `node_modules`, `dist`, `certs`, and other unneeded files from the build context
