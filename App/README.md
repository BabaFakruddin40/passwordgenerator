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

The app is containerized using a multi-stage Dockerfile: it builds the static site with Node.js, then serves the output with Nginx (`-alpine-slim` image).

### Build and run with Docker

```bash
docker build -t password-generator .
docker run -d -p 8080:80 --name password-generator password-generator
```

The app will be available at [http://localhost:8080](http://localhost:8080).

### Build and run with Docker Compose

```bash
docker compose up -d --build
```

This starts the app on [http://localhost:8080](http://localhost:8080). To stop it:

```bash
docker compose down
```

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
- `nginx.conf` – SPA fallback routing and static asset caching
- `docker-compose.yml` – local orchestration, maps host port `8080` to container port `80`
- `.dockerignore` – excludes `node_modules`, `dist`, and other unneeded files from the build context
