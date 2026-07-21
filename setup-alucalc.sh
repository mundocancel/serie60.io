#!/bin/bash
# ============================================================
# MundoCanceles · ALUCALC 3D · Setup Script
# Ejecutar: chmod +x setup-alucalc.sh && ./setup-alucalc.sh
# ============================================================
set -e  # Detener si hay error

echo "🔧 MundoCanceles · ALUCALC 3D · Configurando repositorio..."

# Configuración
REPO_NAME="mundocanceles-alucalc"
GIT_USER=""  # Déjalo vacío si no quieres remote todavía

# 1. Crear estructura de directorios
mkdir -p $REPO_NAME/{css,js,assets/icons}
cd $REPO_NAME

# 2. Inicializar Git
git init
git config core.autocrlf false  # CRÍTICO: Evita problemas de saltos de línea Windows/Linux

# 3. .gitignore (esencial)
cat > .gitignore << 'EOF'
# Dependencias
node_modules/

# Sistema
.DS_Store
Thumbs.db
*.log
*.tmp
*.swp
*.swo
*~

# Editor
.vscode/
.idea/
*.sublime-*

# Build (si algún día compilas)
dist/
build/

# Entorno
.env
.env.local
EOF

# 4. LICENSE (MIT, seguro para uso comercial)
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 MundoCanceles

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# 5. README.md
cat > README.md << 'EOF'
# MundoCanceles · ALUCALC 3D · Despiece Técnico

Herramienta interactiva de visualización 3D para canceles de aluminio y vidrio.

## 🚀 Inicio rápido

```bash
# Clonar
git clone https://github.com/tu-usuario/mundocanceles-alucalc.git
cd mundocanceles-alucalc

# Servir (necesitas Node.js)
npx serve .

# O con Python
python3 -m http.server 8000
Abrir http://localhost:8000 en Chrome/Edge/Firefox.

🛠️ Stack
Three.js 0.160 (CDN, sin build)

ES Modules nativos

PBR + HDRI (RoomEnvironment)

CSS Glassmorphism + Modo oscuro

📁 Estructura
text
mundocanceles-alucalc/
├── index.html          # Punto de entrada
├── css/
│   └── style.css       # Estilos
├── js/
│   ├── main.js         # Inicialización
│   ├── scene.js        # Three.js setup
│   ├── controls.js     # Orbit + teclado
│   ├── materials.js    # Materiales PBR
│   ├── window-builder.js  # Construcción 3D
│   ├── components.js   # Lista de partes
│   ├── labels.js       # Etiquetas 3D
│   ├── dimensions.js   # Acotaciones
│   ├── ui-handlers.js  # Eventos UI
│   ├── animation.js    # Loop + overlays
│   └── state.js        # Estado global
└── assets/
    └── icons/
🎮 Controles
🖱️ Arrastrar: rotar

🖱️ Scroll: zoom

⌨️ Flechas: rotar

Teclas: E=Despiece, L=Etiquetas, D=Acotar

📄 Licencia
MIT © MundoCanceles
EOF

============================================================
6. CSS - Extraído del HTML original (sin cambios)
============================================================
cat > css/style.css << 'CSSEOF'
:root {
--accent: #ff6b35;
--accent-soft: #ff8a5c;
--bg: #f4f6fa;
--panel: rgba(255, 255, 255, 0.65);
--panel-solid: #ffffff;
--text: #1a1f2e;
--text-soft: #5a6478;
--border: rgba(255, 255, 255, 0.4);
--scene-bg: #eef1f6;
--success: #22c55e;
--info: #3b82f6;
}
[data-theme="dark"] {
--bg: #0d1117;
--panel: rgba(22, 27, 34, 0.65);
--panel-solid: #161b22;
--text: #e6edf3;
--text-soft: #8b949e;
--border: rgba(255, 255, 255, 0.1);
--scene-bg: #1a1f2e;
}

{ box-sizing: border-box; margin: 0; padding: 0; }
html, body {
height: 100%;
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
background: var(--bg);
color: var(--text);
overflow: hidden;
transition: background 0.3s ease, color 0.3s ease;
}
body {
display: grid;
grid-template-columns: 340px 1fr;
grid-template-rows: 60px 1fr;
grid-template-areas:
"header header"
"sidebar viewport";
}
header {
grid-area: header;
display: flex;
align-items: center;
justify-content: space-between;
padding: 0 24px;
background: var(--panel);
backdrop-filter: blur(20px);
-webkit-backdrop-filter: blur(20px);
border-bottom: 1px solid var(--border);
z-index: 10;
}
.brand { display: flex; align-items: center; gap: 12px; font-weight: 700; }
.brand-logo {
width: 36px; height: 36px;
background: linear-gradient(135deg, var(--accent), var(--accent-soft));
border-radius: 10px;
display: flex; align-items: center; justify-content: center;
color: white; font-weight: 900; font-size: 18px;
box-shadow: 0 4px 12px rgba(255, 107, 53, 0.4);
}
.brand-text { display: flex; flex-direction: column; line-height: 1.1; }
.brand-title { color: var(--text); font-size: 16px; letter-spacing: 0.5px; }
.brand-sub { font-size: 10px; font-weight: 500; color: var(--text-soft); letter-spacing: 1.5px; }
.header-actions { display: flex; gap: 10px; align-items: center; }
.icon-btn {
width: 38px; height: 38px;
border: 1px solid var(--border);
background: var(--panel);
border-radius: 10px;
cursor: pointer;
display: flex; align-items: center; justify-content: center;
color: var(--text);
transition: all 0.2s ease;
backdrop-filter: blur(10px);
position: relative;
}
.icon-btn:hover { background: var(--accent); color: white; border-color: var(--accent); transform: translateY(-1px); }
.icon-btn.active { background: var(--accent); color: white; border-color: var(--accent); }
.icon-btn svg { width: 18px; height: 18px; }
.btn-label {
position: absolute;
bottom: -20px; left: 50%;
transform: translateX(-50%);
font-size: 9px;
font-weight: 600;
color: var(--text-soft);
white-space: nowrap;
opacity: 0;
transition: opacity 0.2s;
pointer-events: none;
}
.icon-btn:hover .btn-label { opacity: 1; }

aside {
grid-area: sidebar;
background: var(--panel);
backdrop-filter: blur(20px);
-webkit-backdrop-filter: blur(20px);
border-right: 1px solid var(--border);
overflow-y: auto;
padding: 20px;
}
aside::-webkit-scrollbar { width: 6px; }
aside::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }

.section { margin-bottom: 22px; }
.section-title {
font-size: 11px;
font-weight: 700;
letter-spacing: 1.5px;
color: var(--text-soft);
text-transform: uppercase;
margin-bottom: 10px;
display: flex; align-items: center; gap: 6px;
}
.section-title::before {
content: ''; width: 3px; height: 12px;
background: var(--accent); border-radius: 2px;
}

.control-row { margin-bottom: 14px; }
.control-label {
display: flex; justify-content: space-between; align-items: center;
font-size: 13px; font-weight: 500;
margin-bottom: 6px;
}
.control-value {
color: var(--accent); font-weight: 700;
font-variant-numeric: tabular-nums;
}

input[type="range"] {
-webkit-appearance: none; appearance: none;
width: 100%; height: 6px;
background: var(--border);
border-radius: 3px; outline: none;
cursor: pointer;
}
input[type="range"]::-webkit-slider-thumb {
-webkit-appearance: none; appearance: none;
width: 18px; height: 18px;
background: var(--accent);
border-radius: 50%;
cursor: pointer;
box-shadow: 0 2px 8px rgba(255, 107, 53, 0.5);
}
input[type="range"]::-moz-range-thumb {
width: 18px; height: 18px;
background: var(--accent);
border-radius: 50%;
cursor: pointer;
border: none;
}

.type-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
.type-btn {
padding: 12px 8px;
background: var(--panel-solid);
border: 2px solid var(--border);
border-radius: 10px;
cursor: pointer;
font-size: 12px;
font-weight: 600;
color: var(--text);
transition: all 0.2s ease;
display: flex; flex-direction: column; align-items: center; gap: 6px;
}
.type-btn:hover { border-color: var(--accent-soft); transform: translateY(-2px); }
.type-btn.active {
border-color: var(--accent);
background: linear-gradient(135deg, rgba(255,107,53,0.1), rgba(255,138,92,0.05));
color: var(--accent);
}
.type-btn svg { width: 32px; height: 32px; }

.color-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 8px; }
.color-swatch {
aspect-ratio: 1;
border-radius: 10px;
cursor: pointer;
border: 2px solid var(--border);
transition: all 0.2s ease;
position: relative;
}
.color-swatch:hover { transform: scale(1.08); }
.color-swatch.active {
border-color: var(--accent);
box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.2);
}
.color-swatch.active::after {
content: '✓';
position: absolute; inset: 0;
display: flex; align-items: center; justify-content: center;
color: white; font-weight: 900;
text-shadow: 0 1px 2px rgba(0,0,0,0.5);
}

.component-list { display: flex; flex-direction: column; gap: 6px; }
.component-item {
display: grid;
grid-template-columns: 28px 1fr auto;
align-items: center;
gap: 10px;
padding: 8px 10px;
background: var(--panel-solid);
border: 1px solid var(--border);
border-radius: 8px;
font-size: 12px;
transition: all 0.2s ease;
cursor: pointer;
}
.component-item:hover {
border-color: var(--accent);
transform: translateX(2px);
}
.component-item.highlighted {
border-color: var(--accent);
background: linear-gradient(135deg, rgba(255,107,53,0.12), rgba(255,138,92,0.04));
box-shadow: 0 2px 8px rgba(255, 107, 53, 0.15);
}
.component-icon {
width: 28px; height: 28px;
border-radius: 6px;
display: flex; align-items: center; justify-content: center;
font-size: 14px;
background: rgba(255, 107, 53, 0.1);
color: var(--accent);
}
.component-name { font-weight: 600; color: var(--text); line-height: 1.2; }
.component-spec { font-size: 10px; color: var(--text-soft); margin-top: 2px; }
.component-qty {
font-size: 11px;
font-weight: 700;
color: var(--accent);
background: rgba(255, 107, 53, 0.1);
padding: 2px 8px;
border-radius: 10px;
font-variant-numeric: tabular-nums;
}

.info-table { font-size: 12px; color: var(--text-soft); line-height: 1.6; }
.info-row {
display: flex; justify-content: space-between;
padding: 5px 0;
border-bottom: 1px solid var(--border);
}
.info-row:last-child { border-bottom: none; }
.info-row span:last-child { color: var(--accent); font-weight: 600; font-variant-numeric: tabular-nums; }

.viewport {
grid-area: viewport;
position: relative;
overflow: hidden;
background: var(--scene-bg);
transition: background 0.3s ease;
}
#canvas3d { width: 100%; height: 100%; display: block; outline: none; }
#canvas3d:focus { box-shadow: inset 0 0 0 3px rgba(255, 107, 53, 0.3); }

#overlaySvg {
position: absolute;
inset: 0;
width: 100%; height: 100%;
pointer-events: none;
z-index: 2;
}

.dimension-label {
position: absolute;
background: rgba(255, 255, 255, 0.9);
backdrop-filter: blur(10px);
-webkit-backdrop-filter: blur(10px);
border: 1px solid var(--accent);
padding: 5px 10px;
border-radius: 6px;
color: var(--accent);
font-weight: 700;
font-size: 12px;
box-shadow: 0 2px 8px rgba(255, 107, 53, 0.2);
pointer-events: none;
user-select: none;
transform: translate(-50%, -50%);
white-space: nowrap;
font-variant-numeric: tabular-nums;
z-index: 3;
font-family: 'SF Mono', Monaco, monospace;
}
[data-theme="dark"] .dimension-label {
background: rgba(22, 27, 34, 0.9);
}
.dimension-label .unit { font-weight: 400; color: var(--text-soft); margin-left: 2px; font-size: 10px; }

.component-label-3d {
position: absolute;
background: var(--panel-solid);
border: 1px solid var(--border);
padding: 4px 10px;
border-radius: 6px;
font-size: 11px;
font-weight: 600;
color: var(--text);
pointer-events: none;
user-select: none;
transform: translate(-50%, -50%);
white-space: nowrap;
z-index: 3;
box-shadow: 0 2px 6px rgba(0,0,0,0.1);
opacity: 0;
transition: opacity 0.3s ease;
}
.component-label-3d.visible { opacity: 1; }
.component-label-3d::before {
content: '';
position: absolute;
width: 6px; height: 6px;
background: var(--accent);
border-radius: 50%;
left: -10px; top: 50%;
transform: translateY(-50%);
box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.2);
}

.view-controls {
position: absolute;
top: 20px; left: 20px;
display: flex;
flex-direction: column;
gap: 6px;
z-index: 5;
}
.view-btn {
width: 42px; height: 42px;
background: var(--panel);
backdrop-filter: blur(10px);
-webkit-backdrop-filter: blur(10px);
border: 1px solid var(--border);
border-radius: 10px;
cursor: pointer;
display: flex; align-items: center; justify-content: center;
color: var(--text);
transition: all 0.2s ease;
font-size: 10px;
font-weight: 700;
letter-spacing: 0.5px;
}
.view-btn:hover { background: var(--accent); color: white; border-color: var(--accent); }
.view-btn.active { background: var(--accent); color: white; border-color: var(--accent); }

.hud {
position: absolute;
bottom: 20px; left: 20px;
display: flex; gap: 10px;
z-index: 5;
}
.hud-chip {
background: var(--panel);
backdrop-filter: blur(10px);
border: 1px solid var(--border);
padding: 8px 14px;
border-radius: 20px;
font-size: 12px;
font-weight: 600;
color: var(--text);
display: flex; align-items: center; gap: 6px;
}
.hud-chip .dot {
width: 8px; height: 8px;
background: var(--success);
border-radius: 50%;
box-shadow: 0 0 8px var(--success);
animation: pulse 2s infinite;
}
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }

.mode-indicator {
position: absolute;
top: 20px; right: 20px;
background: var(--panel);
backdrop-filter: blur(10px);
border: 1px solid var(--border);
padding: 10px 16px;
border-radius: 10px;
font-size: 12px;
color: var(--text);
z-index: 5;
display: flex; align-items: center; gap: 10px;
}
.mode-indicator .badge {
background: var(--accent);
color: white;
padding: 2px 8px;
border-radius: 10px;
font-size: 10px;
font-weight: 700;
letter-spacing: 0.5px;
}

.help-hint {
position: absolute;
bottom: 20px; right: 20px;
background: var(--panel);
backdrop-filter: blur(10px);
border: 1px solid var(--border);
padding: 10px 14px;
border-radius: 10px;
font-size: 11px;
color: var(--text-soft);
max-width: 220px;
line-height: 1.5;
z-index: 5;
}
.help-hint kbd {
background: var(--panel-solid);
border: 1px solid var(--border);
padding: 1px 5px;
border-radius: 4px;
font-size: 10px;
font-family: 'SF Mono', Monaco, monospace;
color: var(--text);
}

.loader {
position: absolute;
inset: 0;
display: flex;
align-items: center;
justify-content: center;
flex-direction: column;
gap: 16px;
background: var(--scene-bg);
z-index: 100;
transition: opacity 0.5s ease;
}
.loader.hidden { opacity: 0; pointer-events: none; }
.spinner {
width: 48px; height: 48px;
border: 3px solid var(--border);
border-top-color: var(--accent);
border-radius: 50%;
animation: spin 1s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
.loader-text { font-size: 13px; color: var(--text-soft); font-weight: 500; }

@media (max-width: 768px) {
body {
grid-template-columns: 1fr;
grid-template-rows: 60px 1fr auto;
grid-template-areas: "header" "viewport" "sidebar";
}
aside { max-height: 45vh; border-right: none; border-top: 1px solid var(--border); }
.help-hint { display: none; }
}
CSSEOF

============================================================
7. JavaScript - Archivos modulares
============================================================
--- state.js ---
cat > js/state.js << 'EOF'
// ============================================================
// MundoCanceles · ALUCALC 3D · Estado Global
// ============================================================
export const state = {
width: 120, // cm
height: 140, // cm
glass: 6, // mm
color: 0xE8E8E8, // hex
type: 'fijo', // 'fijo' | '1hoja' | '2hojas' | 'corrediza'
exploded: false,
showLabels: false,
showDimensions: true,
viewMode: '3d' // '3d' | 'front' | 'side' | 'top'
};

export const typeLabels = {
fijo: 'Fijo',
'1hoja': '1 Hoja',
'2hojas': '2 Hojas',
corrediza: 'Corrediza'
};

export const FRAME_PROFILE = 0.06; // metros
export const FRAME_DEPTH = 0.08; // metros

export function meters(cm) {
return cm / 100;
}

// Registro de componentes 3D (se llena desde window-builder)
export const components = [];
EOF

--- materials.js ---
cat > js/materials.js << 'EOF'
// ============================================================
// MundoCanceles · Materiales PBR
// ============================================================
import * as THREE from 'three';
import { state } from './state.js';

export const glassMaterial = new THREE.MeshPhysicalMaterial({
color: 0x99B3CC,
metalness: 0,
roughness: 0.02,
transmission: 0.96,
thickness: 0.5,
ior: 1.52,
clearcoat: 1.0,
clearcoatRoughness: 0.05,
transparent: true,
attenuationColor: new THREE.Color(0xAACCEE),
attenuationDistance: 0.5,
envMapIntensity: 1.0,
side: THREE.DoubleSide
});

export const frameMaterial = new THREE.MeshPhysicalMaterial({
color: state.color,
metalness: 0.85,
roughness: 0.25,
clearcoat: 0.6,
clearcoatRoughness: 0.15,
envMapIntensity: 1.5
});

export const handleMaterial = new THREE.MeshPhysicalMaterial({
color: 0x333333,
metalness: 0.95,
roughness: 0.15,
clearcoat: 0.8,
clearcoatRoughness: 0.1,
envMapIntensity: 1.5
});

export const floorMat = new THREE.MeshStandardMaterial({
color: 0xd8dde5,
roughness: 0.8,
metalness: 0.1
});
EOF

--- scene.js ---
cat > js/scene.js << 'EOF'
// ============================================================
// MundoCanceles · Escena Three.js
// ============================================================
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';
import { floorMat } from './materials.js';

const viewport = document.getElementById('viewport');
const canvas = document.getElementById('canvas3d');

export const scene = new THREE.Scene();
scene.background = new THREE.Color(0xeef1f6);

export const camera = new THREE.PerspectiveCamera(
35, viewport.clientWidth / viewport.clientHeight, 0.1, 100
);
camera.position.set(0, 0, 5);

export const renderer = new THREE.WebGLRenderer({
canvas,
antialias: true,
alpha: true,
powerPreference: 'high-performance'
});
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
renderer.setSize(viewport.clientWidth, viewport.clientHeight);
renderer.shadowMap.enabled = true;
renderer.shadowMap.type = THREE.PCFSoftShadowMap;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1.2;
renderer.outputColorSpace = THREE.SRGBColorSpace;

// Entorno HDRI
const pmremGenerator = new THREE.PMREMGenerator(renderer);
const roomEnv = new RoomEnvironment();
scene.environment = pmremGenerator.fromScene(roomEnv, 0.04).texture;
roomEnv.dispose();

// Iluminación
const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
scene.add(ambientLight);

const keyLight = new THREE.DirectionalLight(0xffffff, 2.0);
keyLight.position.set(5, 8, 5);
keyLight.castShadow = true;
keyLight.shadow.mapSize.set(2048, 2048);
scene.add(keyLight);

const rimLight = new THREE.DirectionalLight(0xFF6B35, 0.6);
rimLight.position.set(-5, 3, -5);
scene.add(rimLight);

const fillLight = new THREE.DirectionalLight(0x8899AA, 0.4);
fillLight.position.set(3, -2, 4);
scene.add(fillLight);

// Controles de órbita
export const controls = new OrbitControls(camera, canvas);
controls.enableDamping = true;
controls.dampingFactor = 0.08;
controls.minDistance = 2;
controls.maxDistance = 10;
controls.maxPolarAngle = Math.PI * 0.9;

// Grupo principal del cancel
export const windowGroup = new THREE.Group();
scene.add(windowGroup);

// Suelo
const floor = new THREE.Mesh(new THREE.CircleGeometry(4, 64), floorMat);
floor.rotation.x = -Math.PI / 2;
floor.position.y = -1.5;
floor.receiveShadow = true;
scene.add(floor);

// Redimensionar
window.addEventListener('resize', () => {
const w = viewport.clientWidth;
const h = viewport.clientHeight;
camera.aspect = w / h;
camera.updateProjectionMatrix();
renderer.setSize(w, h);
});
EOF

--- controls.js ---
cat > js/controls.js << 'EOF'
// ============================================================
// MundoCanceles · Controles de cámara
// ============================================================
import * as THREE from 'three';
import { camera, controls } from './scene.js';

export function setupKeyboardControls(canvas) {
canvas.addEventListener('keydown', (e) => {
const rotateSpeed = 0.08;
const offset = new THREE.Vector3().subVectors(camera.position, controls.target);
const spherical = new THREE.Spherical().setFromVector3(offset);

switch(e.key) {
case 'ArrowLeft': spherical.theta -= rotateSpeed; e.preventDefault(); break;
case 'ArrowRight': spherical.theta += rotateSpeed; e.preventDefault(); break;
case 'ArrowUp': spherical.phi = Math.max(0.1, spherical.phi - rotateSpeed); e.preventDefault(); break;
case 'ArrowDown': spherical.phi = Math.min(Math.PI - 0.1, spherical.phi + rotateSpeed); e.preventDefault(); break;
default: return;
}
offset.setFromSpherical(spherical);
camera.position.copy(controls.target).add(offset);
camera.lookAt(controls.target);
});
}

export function setView(view) {
const distance = 5;
controls.enabled = view === '3d';
switch(view) {
case 'front':
camera.position.set(0, 0, distance);
controls.target.set(0, 0, 0);
break;
case 'side':
camera.position.set(distance, 0, 0);
controls.target.set(0, 0, 0);
break;
case 'top':
camera.position.set(0, distance, 0.01);
controls.target.set(0, 0, 0);
break;
case '3d':
default:
camera.position.set(0, 0, distance);
controls.target.set(0, 0, 0);
break;
}
camera.lookAt(controls.target);
controls.update();
}
EOF

--- window-builder.js ---
cat > js/window-builder.js << 'EOF'
// ============================================================
// MundoCanceles · Constructor 3D del Cancel
// ============================================================
import * as THREE from 'three';
import { RoundedBoxGeometry } from 'three/addons/geometries/RoundedBoxGeometry.js';
import { windowGroup } from './scene.js';
import { frameMaterial, glassMaterial, handleMaterial } from './materials.js';
import { state, FRAME_PROFILE, FRAME_DEPTH, meters, components } from './state.js';
import { updateComponentList } from './components.js';

function createFramePiece(width, height, depth, position, name, explodeOffset) {
const geo = new RoundedBoxGeometry(width, height, depth, 4, 0.015);
const mesh = new THREE.Mesh(geo, frameMaterial);
mesh.position.copy(position);
mesh.castShadow = true;
mesh.receiveShadow = true;
mesh.userData = {
name,
basePosition: position.clone(),
explodeOffset: explodeOffset || new THREE.Vector3(),
currentOffset: new THREE.Vector3()
};
components.push(mesh);
return mesh;
}

function createGlassPane(width, height, thickness, position, name, explodeOffset) {
const geo = new THREE.BoxGeometry(width, height, thickness);
const mesh = new THREE.Mesh(geo, glassMaterial);
mesh.position.copy(position);
mesh.userData = {
name,
basePosition: position.clone(),
explodeOffset: explodeOffset || new THREE.Vector3(),
currentOffset: new THREE.Vector3()
};
components.push(mesh);
return mesh;
}

function createHandle(position, name, explodeOffset) {
const handleGeo = new THREE.CylinderGeometry(0.015, 0.015, 0.12, 16);
const handle = new THREE.Mesh(handleGeo, handleMaterial);
handle.rotation.z = Math.PI / 2;
handle.position.copy(position);
handle.castShadow = true;
handle.userData = {
name,
basePosition: position.clone(),
explodeOffset: explodeOffset || new THREE.Vector3(),
currentOffset: new THREE.Vector3()
};
components.push(handle);

const baseGeo = new THREE.CylinderGeometry(0.025, 0.025, 0.02, 16);
const base = new THREE.Mesh(baseGeo, handleMaterial);
base.rotation.z = Math.PI / 2;
base.position.set(position.x, position.y, position.z - 0.01);
base.castShadow = true;
windowGroup.add(base);

return handle;
}

export function buildWindow() {
// Limpiar
while (windowGroup.children.length > 0) {
const child = windowGroup.children[0];
windowGroup.remove(child);
if (child.geometry) child.geometry.dispose();
}
components.length = 0;
document.querySelectorAll('.component-label-3d').forEach(el => el.remove());

const W = meters(state.width);
const H = meters(state.height);
const glassThickness = Math.max(0.005, state.glass * 0.002);
const fp = FRAME_PROFILE;
const fd = FRAME_DEPTH;

// Marco exterior
windowGroup.add(createFramePiece(W + fp, fp, fd, new THREE.Vector3(0, H/2 + fp/2, 0), 'Marco Superior', new THREE.Vector3(0, 0.4, 0)));
windowGroup.add(createFramePiece(W + fp, fp, fd, new THREE.Vector3(0, -H/2 - fp/2, 0), 'Marco Inferior', new THREE.Vector3(0, -0.4, 0)));
windowGroup.add(createFramePiece(fp, H + fp, fd, new THREE.Vector3(-W/2 - fp/2, 0, 0), 'Jamba Izquierda', new THREE.Vector3(-0.4, 0, 0)));
windowGroup.add(createFramePiece(fp, H + fp, fd, new THREE.Vector3(W/2 + fp/2, 0, 0), 'Jamba Derecha', new THREE.Vector3(0.4, 0, 0)));

// Tipo específico
if (state.type === 'fijo') {
windowGroup.add(createGlassPane(W - 0.02, H - 0.02, glassThickness, new THREE.Vector3(0, 0, 0), 'Vidrio Fijo', new THREE.Vector3(0, 0, 0.5)));
} else if (state.type === '1hoja') {
windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(0, 0, 0), 'Montante Central', new THREE.Vector3(0, 0, 0.3)));
windowGroup.add(createGlassPane(W - 0.02, H - 0.02, glassThickness, new THREE.Vector3(0, 0, 0), 'Vidrio Hoja', new THREE.Vector3(0, 0, 0.5)));
windowGroup.add(createHandle(new THREE.Vector3(W/2 - 0.08, 0, fd/2 + 0.02), 'Manija', new THREE.Vector3(0.3, 0, 0.4)));
} else if (state.type === '2hojas') {
windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(0, 0, 0), 'Montante Central', new THREE.Vector3(0, 0, 0.3)));
const paneW = (W - fp * 0.7) / 2 - 0.01;
windowGroup.add(createGlassPane(paneW, H - 0.02, glassThickness, new THREE.Vector3(-(paneW/2 + fp * 0.35 / 2), 0, 0), 'Vidrio Izq.', new THREE.Vector3(-0.3, 0, 0.5)));
windowGroup.add(createGlassPane(paneW, H - 0.02, glassThickness, new THREE.Vector3((paneW/2 + fp * 0.35 / 2), 0, 0), 'Vidrio Der.', new THREE.Vector3(0.3, 0, 0.5)));
windowGroup.add(createHandle(new THREE.Vector3(-0.05, 0, fd/2 + 0.02), 'Manija Izq.', new THREE.Vector3(-0.2, 0, 0.4)));
windowGroup.add(createHandle(new THREE.Vector3(0.05, 0, fd/2 + 0.02), 'Manija Der.', new THREE.Vector3(0.2, 0, 0.4)));
} else if (state.type === 'corrediza') {
const paneW = W * 0.55;
const paneH = H - 0.02;
windowGroup.add(createGlassPane(paneW, paneH, glassThickness, new THREE.Vector3(-W * 0.15, 0, -0.01), 'Hoja Trasera', new THREE.Vector3(-0.3, 0, -0.3)));
windowGroup.add(createGlassPane(paneW, paneH, glassThickness, new THREE.Vector3(W * 0.15, 0, 0.015), 'Hoja Frontal', new THREE.Vector3(0.3, 0, 0.5)));
const railGeo = new RoundedBoxGeometry(W, 0.015, fd * 0.5, 2, 0.005);
const railTop = new THREE.Mesh(railGeo, frameMaterial);
railTop.position.set(0, H/2 - 0.02, 0);
railTop.castShadow = true;
railTop.userData = { name: 'Riel Superior', basePosition: railTop.position.clone(), explodeOffset: new THREE.Vector3(0, 0.3, 0), currentOffset: new THREE.Vector3() };
components.push(railTop);
windowGroup.add(railTop);
const railBot = new THREE.Mesh(railGeo.clone(), frameMaterial);
railBot.position.set(0, -H/2 + 0.02, 0);
railBot.castShadow = true;
railBot.userData = { name: 'Riel Inferior', basePosition: railBot.position.clone(), explodeOffset: new THREE.Vector3(0, -0.3, 0), currentOffset: new THREE.Vector3() };
components.push(railBot);
windowGroup.add(railBot);
windowGroup.add(createHandle(new THREE.Vector3(W * 0.15 - paneW/2 + 0.08, 0, fd/2 + 0.02), 'Manija Corrediza', new THREE.Vector3(0.3, 0, 0.4)));
}

updateComponentList();
updateAriaLabel();
}

function updateAriaLabel() {
const canvas = document.getElementById('canvas3d');
const typeLabel = { fijo:'Fijo', '1hoja':'1 Hoja', '2hojas':'2 Hojas', corrediza:'Corrediza' }[state.type];
canvas.setAttribute('aria-label', Visor 3D de cancel MundoCanceles. Tipo: ${typeLabel}. Dimensiones: ${state.width}x${state.height} cm.);
}
EOF

--- components.js ---
cat > js/components.js << 'EOF'
// ============================================================
// MundoCanceles · Lista de Componentes y Especificaciones
// ============================================================
import { state, components } from './state.js';
import { camera, controls } from './scene.js';
import * as THREE from 'three';

export function updateComponentList() {
const list = document.getElementById('componentList');
list.innerHTML = '';

const grouped = {};
components.forEach(c => {
const name = c.userData.name;
if (!grouped[name]) grouped[name] = { count: 0, mesh: c };
grouped[name].count++;
});

const iconMap = {
'Marco': '▬', 'Jamba': '▮', 'Montante': '▮',
'Vidrio': '◻', 'Manija': '◉', 'Riel': '═', 'Hoja': '◻'
};

Object.entries(grouped).forEach(([name, data]) => {
const icon = Object.entries(iconMap).find(([k]) => name.includes(k))?.[1] || '●';
const spec = getComponentSpec(name);
const item = document.createElement('div');
item.className = 'component-item';
item.dataset.name = name;
item.innerHTML = `

<div class="component-icon">${icon}</div> <div> <div class="component-name">${name}</div> <div class="component-spec">${spec}</div> </div> <div class="component-qty">×${data.count}</div> `; item.addEventListener('mouseenter', () => highlightComponent(name, true)); item.addEventListener('mouseleave', () => highlightComponent(name, false)); item.addEventListener('click', () => focusComponent(name)); list.appendChild(item); }); }
function getComponentSpec(name) {
const W = state.width;
const H = state.height;
if (name.includes('Superior') || name.includes('Inferior')) return ${W} cm · Perfil 60mm;
if (name.includes('Jamba')) return ${H} cm · Perfil 60mm;
if (name.includes('Montante')) return ${H} cm · Perfil 42mm;
if (name.includes('Vidrio') || name.includes('Hoja')) return ${state.glass}mm · ${W}×${H}cm;
if (name.includes('Manija')) return 'Aluminio · 120mm';
if (name.includes('Riel')) return ${W} cm · Aluminio;
return '';
}

function highlightComponent(name, highlight) {
components.forEach(c => {
if (c.userData.name === name) {
if (highlight) {
c.userData._origEmissive = c.material.emissive?.clone();
if (c.material.emissive) c.material.emissive.setHex(0xff6b35);
if (c.material.emissiveIntensity !== undefined) c.material.emissiveIntensity = 0.3;
} else {
if (c.material.emissive && c.userData._origEmissive) {
c.material.emissive.copy(c.userData._origEmissive);
c.material.emissiveIntensity = 0;
}
}
}
});
document.querySelectorAll('.component-item').forEach(item => {
if (item.dataset.name === name) item.classList.toggle('highlighted', highlight);
});
}

function focusComponent(name) {
const comp = components.find(c => c.userData.name === name);
if (!comp) return;
const worldPos = new THREE.Vector3();
comp.getWorldPosition(worldPos);
controls.target.copy(worldPos);
camera.position.copy(worldPos).add(new THREE.Vector3(0, 0, 2));
controls.update();
}

export function updateInfo() {
const W = state.width / 100;
const H = state.height / 100;
const area = W * H;
const perim = 2 * (W + H);
const weight = (area * 12 + perim * 1.8).toFixed(1);
const typeLabel = { fijo:'Fijo', '1hoja':'1 Hoja', '2hojas':'2 Hojas', corrediza:'Corrediza' }[state.type];
document.getElementById('infoArea').textContent = area.toFixed(2) + ' m²';
document.getElementById('infoPerim').textContent = perim.toFixed(2) + ' m';
document.getElementById('infoWeight').textContent = weight + ' kg';
document.getElementById('infoType').textContent = typeLabel;
}
EOF

--- labels.js ---
cat > js/labels.js << 'EOF'
// ============================================================
// MundoCanceles · Etiquetas 3D y Proyección
// ============================================================
import { state, components } from './state.js';
import { camera } from './scene.js';
import * as THREE from 'three';

const viewport = document.getElementById('viewport');
const overlaySvg = document.getElementById('overlaySvg');
const labelWidth = document.getElementById('labelWidth');
const labelHeight = document.getElementById('labelHeight');

export function projectToScreen(worldPos) {
const vec = worldPos.clone().project(camera);
const rect = document.getElementById('canvas3d').getBoundingClientRect();
return {
x: (vec.x * 0.5 + 0.5) * rect.width,
y: (-vec.y * 0.5 + 0.5) * rect.height
};
}

export function updateLabels() {
const labelWidthVal = document.getElementById('labelWidthVal');
const labelHeightVal = document.getElementById('labelHeightVal');
labelWidthVal.textContent = state.width;
labelHeightVal.textContent = state.height;
labelWidth.style.display = state.showDimensions ? 'block' : 'none';
labelHeight.style.display = state.showDimensions ? 'block' : 'none';
}

export function positionLabels() {
if (!state.showDimensions) return;
const W = state.width / 100;
const H = state.height / 100;
const fp = 0.06;

const widthWorld = new THREE.Vector3(0, -H/2 - fp - 0.3, 0);
const wScreen = projectToScreen(widthWorld);
labelWidth.style.left = wScreen.x + 'px';
labelWidth.style.top = wScreen.y + 'px';

const heightWorld = new THREE.Vector3(W/2 + fp + 0.35, 0, 0);
const hScreen = projectToScreen(heightWorld);
labelHeight.style.left = hScreen.x + 'px';
labelHeight.style.top = hScreen.y + 'px';
}

export function update3DLabels() {
document.querySelectorAll('.component-label-3d').forEach(el => el.remove());
overlaySvg.querySelectorAll('.leader-line').forEach(el => el.remove());

if (!state.showLabels && !state.exploded) return;

const seen = new Set();
components.forEach(c => {
const name = c.userData.name;
if (seen.has(name)) return;
seen.add(name);

const worldPos = new THREE.Vector3();
c.getWorldPosition(worldPos);
const screen = projectToScreen(worldPos);

// Etiqueta HTML
const label = document.createElement('div');
label.className = 'component-label-3d visible';
label.textContent = name;
label.style.left = (screen.x + 20) + 'px';
label.style.top = screen.y + 'px';
viewport.appendChild(label);

// Línea guía SVG
const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
line.setAttribute('x1', screen.x);
line.setAttribute('y1', screen.y);
line.setAttribute('x2', screen.x + 20);
line.setAttribute('y2', screen.y);
line.setAttribute('stroke', '#ff6b35');
line.setAttribute('stroke-width', '1');
line.setAttribute('stroke-dasharray', '3,2');
line.setAttribute('opacity', '0.6');
line.classList.add('leader-line');
overlaySvg.appendChild(line);

const dot = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
dot.setAttribute('cx', screen.x);
dot.setAttribute('cy', screen.y);
dot.setAttribute('r', '3');
dot.setAttribute('fill', '#ff6b35');
dot.classList.add('leader-line');
overlaySvg.appendChild(dot);
});
}
EOF

--- dimensions.js ---
cat > js/dimensions.js << 'EOF'
// ============================================================
// MundoCanceles · Acotaciones CAD
// ============================================================
import { state, meters, FRAME_PROFILE } from './state.js';
import { projectToScreen } from './labels.js';
import * as THREE from 'three';

const overlaySvg = document.getElementById('overlaySvg');

export function drawDimensionLines() {
overlaySvg.querySelectorAll('.dim-line').forEach(el => el.remove());
if (!state.showDimensions) return;

const W = meters(state.width);
const H = meters(state.height);
const fp = FRAME_PROFILE;

const wStartWorld = new THREE.Vector3(-W/2 - fp, -H/2 - fp - 0.2, 0);
const wEndWorld = new THREE.Vector3(W/2 + fp, -H/2 - fp - 0.2, 0);
drawDimLine(projectToScreen(wStartWorld), projectToScreen(wEndWorld));

const hStartWorld = new THREE.Vector3(W/2 + fp + 0.25, -H/2 - fp, 0);
const hEndWorld = new THREE.Vector3(W/2 + fp + 0.25, H/2 + fp, 0);
drawDimLine(projectToScreen(hStartWorld), projectToScreen(hEndWorld));
}

function drawDimLine(start, end) {
const svg = overlaySvg;

// Línea principal
const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
line.setAttribute('x1', start.x); line.setAttribute('y1', start.y);
line.setAttribute('x2', end.x); line.setAttribute('y2', end.y);
line.setAttribute('stroke', '#ff6b35'); line.setAttribute('stroke-width', '1.5');
line.classList.add('dim-line');
svg.appendChild(line);

// Flechas
const arrowSize = 6;
const angle = Math.atan2(end.y - start.y, end.x - start.x);

['start', 'end'].forEach((pos, i) => {
const point = i === 0 ? start : end;
const dir = i === 0 ? 1 : -1;
const poly = document.createElementNS('http://www.w3.org/2000/svg', 'polygon');
const p1 = {
x: point.x + dir * arrowSize * Math.cos(angle - Math.PI/6),
y: point.y + dir * arrowSize * Math.sin(angle - Math.PI/6)
};
const p2 = {
x: point.x + dir * arrowSize * Math.cos(angle + Math.PI/6),
y: point.y + dir * arrowSize * Math.sin(angle + Math.PI/6)
};
poly.setAttribute('points', ${point.x},${point.y} ${p1.x},${p1.y} ${p2.x},${p2.y});
poly.setAttribute('fill', '#ff6b35');
poly.classList.add('dim-line');
svg.appendChild(poly);
});
}
EOF

--- ui-handlers.js ---
cat > js/ui-handlers.js << 'EOF'
// ============================================================
// MundoCanceles · Manejadores de Interfaz
// ============================================================
import { state } from './state.js';
import { buildWindow } from './window-builder.js';
import { updateLabels } from './labels.js';
import { updateInfo } from './components.js';
import { frameMaterial, glassMaterial, floorMat } from './materials.js';
import { scene, controls, camera } from './scene.js';
import { setView } from './controls.js';

// Variables de explosión (compartidas con animation.js)
export let explodeTarget = 0;
export let explodeCurrent = 0;

function rebuildAll() {
buildWindow();
updateLabels();
updateInfo();
}

export function setupUI() {
// Sliders
document.getElementById('widthSlider').addEventListener('input', e => {
state.width = parseInt(e.target.value);
document.getElementById('widthVal').textContent = state.width + ' cm';
rebuildAll();
});
document.getElementById('heightSlider').addEventListener('input', e => {
state.height = parseInt(e.target.value);
document.getElementById('heightVal').textContent = state.height + ' cm';
rebuildAll();
});
document.getElementById('glassSlider').addEventListener('input', e => {
state.glass = parseInt(e.target.value);
document.getElementById('glassVal').textContent = state.glass + ' mm';
glassMaterial.thickness = state.glass * 0.1;
rebuildAll();
});

// Tipo de cancel
document.querySelectorAll('.type-btn').forEach(btn => btn.addEventListener('click', () => {
document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
btn.classList.add('active');
state.type = btn.dataset.type;
rebuildAll();
}));

// Color
document.querySelectorAll('.color-swatch').forEach(swatch => swatch.addEventListener('click', () => {
document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
swatch.classList.add('active');
state.color = parseInt(swatch.dataset.color.replace('#', ''), 16);
frameMaterial.color.setHex(state.color);
}));

// Botones header
document.getElementById('explodeBtn').addEventListener('click', toggleExplode);
document.getElementById('labelsBtn').addEventListener('click', () => {
state.showLabels = !state.showLabels;
document.getElementById('labelsBtn').classList.toggle('active', state.showLabels);
updateModeIndicator();
});
document.getElementById('dimsBtn').addEventListener('click', () => {
state.showDimensions = !state.showDimensions;
document.getElementById('dimsBtn').classList.toggle('active', state.showDimensions);
updateLabels();
updateModeIndicator();
});
document.getElementById('resetBtn').addEventListener('click', resetView);
document.getElementById('themeBtn').addEventListener('click', toggleTheme);

// Vistas
document.querySelectorAll('.view-btn').forEach(btn => btn.addEventListener('click', () => {
document.querySelectorAll('.view-btn').forEach(b => b.classList.remove('active'));
btn.classList.add('active');
state.viewMode = btn.dataset.view;
setView(btn.dataset.view);
updateModeIndicator();
}));
}

function toggleExplode() {
state.exploded = !state.exploded;
document.getElementById('explodeBtn').classList.toggle('active', state.exploded);
explodeTarget = state.exploded ? 1 : 0;
updateModeIndicator();
}

function resetView() {
camera.position.set(0, 0, 5);
controls.target.set(0, 0, 0);
controls.update();
state.viewMode = '3d';
document.querySelectorAll('.view-btn').forEach(b => b.classList.toggle('active', b.dataset.view === '3d'));
updateModeIndicator();
}

function toggleTheme() {
const current = document.body.getAttribute('data-theme');
const themeIcon = document.getElementById('themeIcon');
if (current === 'dark') {
document.body.removeAttribute('data-theme');
scene.background = new THREE.Color(0xeef1f6);
floorMat.color.setHex(0xd8dde5);
themeIcon.innerHTML = '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/>';
} else {
document.body.setAttribute('data-theme', 'dark');
scene.background = new THREE.Color(0x1a1f2e);
floorMat.color.setHex(0x2a2f3e);
themeIcon.innerHTML = '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>';
}
}

export function updateModeIndicator() {
const modes = [];
if (state.exploded) modes.push('DESPIECE');
if (state.showLabels) modes.push('ETIQUETAS');
if (state.showDimensions) modes.push('ACOTADO');
modes.push(state.viewMode.toUpperCase());

document.getElementById('modeText').textContent =
state.viewMode === '3d' ? 'Vista 3D' :
state.viewMode === 'front' ? 'Vista Frontal' :
state.viewMode === 'side' ? 'Vista Lateral' : 'Vista Superior';
document.getElementById('modeBadge').textContent = modes.slice(0, 2).join(' · ');
}
EOF

--- animation.js ---
cat > js/animation.js << 'EOF'
// ============================================================
// MundoCanceles · Bucle de Animación y Overlays
// ============================================================
import { components } from './state.js';
import { positionLabels, update3DLabels } from './labels.js';
import { drawDimensionLines } from './dimensions.js';
import { explodeCurrent, explodeTarget } from './ui-handlers.js';

export function animateOverlays() {
// Suavizado de explosión
const delta = explodeTarget - explodeCurrent;
if (Math.abs(delta) < 0.001) {
explodeCurrent = explodeTarget;
} else {
explodeCurrent += delta * 0.08;
}

// Aplicar offset a componentes
components.forEach(c => {
if (c.userData.basePosition && c.userData.explodeOffset) {
const target = c.userData.explodeOffset.clone().multiplyScalar(explodeCurrent);
c.position.copy(c.userData.basePosition).add(target);
}
});

// Actualizar overlays SVG
positionLabels();
drawDimensionLines();
update3DLabels();
}

// Contador FPS
let frameCount = 0;
let lastFpsTime = performance.now();

export function updateFPS() {
frameCount++;
const now = performance.now();
if (now - lastFpsTime >= 1000) {
document.getElementById('fpsCounter').textContent = frameCount + ' FPS';
frameCount = 0;
lastFpsTime = now;
}
}
EOF

--- main.js ---
cat > js/main.js << 'EOF'
// ============================================================
// MundoCanceles · ALUCALC 3D · Punto de Entrada
// ============================================================
import { scene, camera, renderer, controls } from './scene.js';
import { setupKeyboardControls } from './controls.js';
import { buildWindow } from './window-builder.js';
import { updateLabels } from './labels.js';
import { updateInfo } from './components.js';
import { setupUI, updateModeIndicator } from './ui-handlers.js';
import { animateOverlays, updateFPS } from './animation.js';

// Configurar UI
setupUI();
setupKeyboardControls(document.getElementById('canvas3d'));

// Construcción inicial
buildWindow();
updateLabels();
updateInfo();
updateModeIndicator();

// Ocultar loader
setTimeout(() => {
document.getElementById('loader').classList.add('hidden');
}, 600);

// Bucle de renderizado
function animate() {
requestAnimationFrame(animate);
controls.update();
animateOverlays();
updateFPS();
renderer.render(scene, camera);
}

animate();

// Enfocar canvas para teclado
setTimeout(() => document.getElementById('canvas3d').focus(), 700);

console.log('✅ MundoCanceles · ALUCALC Despiece Técnico inicializado');
EOF

============================================================
8. INDEX.HTML (con referencias a CSS y JS externos)
============================================================
cat > index.html << 'EOF'

<!DOCTYPE html><html lang="es"> <head> <meta charset="UTF-8" /> <meta name="viewport" content="width=device-width, initial-scale=1.0" /> <title>MundoCanceles · ALUCALC 3D · Despiece Técnico</title> <link rel="stylesheet" href="css/style.css" /> </head> <body><header> <div class="brand"> <div class="brand-logo">M</div> <div class="brand-text"> <span class="brand-title">MundoCanceles</span> <span class="brand-sub">ALUCALC · DESPIECE TÉCNICO</span> </div> </div> <div class="header-actions"> <button class="icon-btn" id="explodeBtn" title="Vista de despiece" aria-label="Activar vista de despiece"> <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg> <span class="btn-label">Despiece</span> </button> <button class="icon-btn" id="labelsBtn" title="Mostrar etiquetas" aria-label="Mostrar etiquetas de componentes"> <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg> <span class="btn-label">Etiquetas</span> </button> <button class="icon-btn active" id="dimsBtn" title="Acotaciones" aria-label="Mostrar acotaciones"> <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 3H3v18h18V3z"/><path d="M9 3v18M3 9h18"/></svg> <span class="btn-label">Acotar</span> </button> <button class="icon-btn" id="resetBtn" title="Resetear vista" aria-label="Resetear vista"> <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 3-6.7L3 8"/><path d="M3 3v5h5"/></svg> <span class="btn-label">Reset</span> </button> <button class="icon-btn" id="themeBtn" title="Cambiar tema" aria-label="Cambiar tema"> <svg id="themeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg> <span class="btn-label">Tema</span> </button> </div> </header><aside> <div class="section"> <div class="section-title">Tipo de Cancel</div> <div class="type-grid" id="typeGrid"> <button class="type-btn active" data-type="fijo"> <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="6" width="24" height="20" rx="1"/></svg> Fijo </button> <button class="type-btn" data-type="1hoja"> <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="6" width="24" height="20" rx="1"/><line x1="16" y1="6" x2="16" y2="26"/></svg> 1 Hoja </button> <button class="type-btn" data-type="2hojas"> <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="6" width="24" height="20" rx="1"/><line x1="16" y1="6" x2="16" y2="26"/></svg> 2 Hojas </button> <button class="type-btn" data-type="corrediza"> <svg viewBox="0 0 32 32" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="4" y="6" width="24" height="20" rx="1"/><rect x="6" y="8" width="10" height="16" opacity="0.5"/><rect x="16" y="8" width="10" height="16"/></svg> Corrediza </button> </div> </div> <div class="section"> <div class="section-title">Dimensiones</div> <div class="control-row"> <div class="control-label"><span>Ancho</span><span class="control-value" id="widthVal">120 cm</span></div> <input type="range" id="widthSlider" min="60" max="240" value="120" step="5" /> </div> <div class="control-row"> <div class="control-label"><span>Alto</span><span class="control-value" id="heightVal">140 cm</span></div> <input type="range" id="heightSlider" min="60" max="240" value="140" step="5" /> </div> <div class="control-row"> <div class="control-label"><span>Vidrio</span><span class="control-value" id="glassVal">6 mm</span></div> <input type="range" id="glassSlider" min="3" max="12" value="6" step="1" /> </div> </div> <div class="section"> <div class="section-title">Color del Perfil</div> <div class="color-grid" id="colorGrid"> <div class="color-swatch active" data-color="#E8E8E8" style="background:#E8E8E8" title="Blanco"></div> <div class="color-swatch" data-color="#1a1a1a" style="background:#1a1a1a" title="Negro"></div> <div class="color-swatch" data-color="#B8BCC2" style="background:#B8BCC2" title="Plata"></div> <div class="color-swatch" data-color="#5C4033" style="background:#5C4033" title="Bronce"></div> <div class="color-swatch" data-color="#2F4F4F" style="background:#2F4F4F" title="Verde"></div> <div class="color-swatch" data-color="#C9A961" style="background:linear-gradient(135deg,#C9A961,#8B6914)" title="Dorado"></div> <div class="color-swatch" data-color="#8B0000" style="background:#8B0000" title="Rojo"></div> <div class="color-swatch" data-color="#1E3A5F" style="background:#1E3A5F" title="Azul"></div> <div class="color-swatch" data-color="#6B4423" style="background:linear-gradient(135deg,#8B5A2B,#4A2E17)" title="Madera"></div> <div class="color-swatch" data-color="#4A5568" style="background:#4A5568" title="Grafito"></div> </div> </div> <div class="section"> <div class="section-title">Lista de Componentes</div> <div class="component-list" id="componentList"></div> </div> <div class="section"> <div class="section-title">Especificaciones</div> <div class="info-table"> <div class="info-row"><span>Área total</span><span id="infoArea">1.68 m²</span></div> <div class="info-row"><span>Perímetro</span><span id="infoPerim">5.20 m</span></div> <div class="info-row"><span>Peso estimado</span><span id="infoWeight">28.4 kg</span></div> <div class="info-row"><span>Tipo</span><span id="infoType">Fijo</span></div> <div class="info-row"><span>Perfil</span><span id="infoProfile">Aluminio 6063-T5</span></div> </div> </div> </aside><div class="viewport" id="viewport"> <canvas id="canvas3d" tabindex="0" role="img" aria-label="Visor 3D de cancel MundoCanceles"></canvas> <svg id="overlaySvg"></svg> <div class="view-controls"> <button class="view-btn active" data-view="3d" title="Vista 3D">3D</button> <button class="view-btn" data-view="front" title="Vista Frontal">F</button> <button class="view-btn" data-view="side" title="Vista Lateral">L</button> <button class="view-btn" data-view="top" title="Vista Superior">S</button> </div> <div class="mode-indicator" id="modeIndicator"> <span id="modeText">Vista 3D</span> <span class="badge" id="modeBadge">PBR</span> </div> <div class="dimension-label" id="labelWidth" style="display:none;"> <span class="value" id="labelWidthVal">120</span><span class="unit">cm</span> </div> <div class="dimension-label" id="labelHeight" style="display:none;"> <span class="value" id="labelHeightVal">140</span><span class="unit">cm</span> </div> <div class="hud"> <div class="hud-chip"><span class="dot"></span><span id="fpsCounter">60 FPS</span></div> <div class="hud-chip">PBR · HDRI</div> </div> <div class="help-hint"> <strong style="color:var(--text);">Controles:</strong><br> 🖱️ Arrastra para rotar · Scroll zoom<br> ⌨️ <kbd>←</kbd><kbd>→</kbd><kbd>↑</kbd><kbd>↓</kbd> rotar </div> <div class="loader" id="loader"> <div class="spinner"></div> <div class="loader-text">MundoCanceles · Cargando despiece técnico...</div> </div> </div><script type="importmap"> { "imports": { "three": "https://unpkg.com/three@0.160.0/build/three.module.js", "three/addons/": "https://unpkg.com/three@0.160.0/examples/jsm/" } } </script><script type="module" src="js/main.js"></script></body> </html> EOF
============================================================
9. Git commit inicial
============================================================
git add -A
git commit -m "🚀 Initial commit: MundoCanceles ALUCALC 3D - Despiece Técnico

Three.js 0.160 con PBR + HDRI

4 tipos de cancel (fijo, 1 hoja, 2 hojas, corredizo)

Vista explosionada, etiquetas 3D, acotaciones CAD

Modo oscuro, controles de cámara

Estructura modular ES Modules"

echo ""
echo "✅ Repositorio creado en: ./
R
E
P
O
N
A
M
E
"
e
c
h
o
"
"
e
c
h
o
"
📦
P
a
r
a
s
e
r
v
i
r
l
o
c
a
l
m
e
n
t
e
:
"
e
c
h
o
"
c
d
REPO 
N
​
 AME"echo""echo"📦Paraservirlocalmente:"echo"cdREPO_NAME"
echo " npx serve ."
echo " # o"
echo " python3 -m http.server 8000"
echo ""
echo "🔗 Para conectar con GitHub:"
echo " git remote add origin https://github.com/TU-USUARIO/$REPO_NAME.git"
echo " git branch -M main"
echo " git push -u origin main"
echo ""

text

## Instrucciones para ejecutar

```bash
# 1. Guarda el script
nano setup-alucalc.sh  # Pega el contenido, Ctrl+O, Ctrl+X

# 2. Dale permisos
chmod +x setup-alucalc.sh

# 3. Ejecuta
./setup-alucalc.sh

# 4. Entra al directorio
cd mundocanceles-alucalc

# 5. Sirve localmente (necesitas Node.js)
npx serve .

# O con Python
python3 -m http.server 8000
