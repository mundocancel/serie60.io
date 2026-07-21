import { state } from './state.js';
import { buildWindow } from './window-builder.js';
import { updateLabels } from './labels.js';
import { updateInfo } from './components.js';
import { frameMaterial, glassMaterial, floorMat } from './materials.js';
import { scene, controls, camera } from './scene.js';
import { setView } from './controls.js';
import { setExplodeTarget } from './animation.js';

function rebuildAll() {
  buildWindow();
  updateLabels();
  updateInfo();
}

export function setupUI() {
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

  document.querySelectorAll('.type-btn').forEach(btn => btn.addEventListener('click', () => {
    document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    state.type = btn.dataset.type;
    rebuildAll();
  }));

  document.querySelectorAll('.color-swatch').forEach(swatch => swatch.addEventListener('click', () => {
    document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
    swatch.classList.add('active');
    state.color = parseInt(swatch.dataset.color.replace('#', ''), 16);
    frameMaterial.color.setHex(state.color);
  }));

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
  setExplodeTarget(state.exploded ? 1 : 0);
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
