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

    const label = document.createElement('div');
    label.className = 'component-label-3d visible';
    label.textContent = name;
    label.style.left = (screen.x + 20) + 'px';
    label.style.top = screen.y + 'px';
    viewport.appendChild(label);

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
