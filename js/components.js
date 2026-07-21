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
      <div class="component-icon">${icon}</div>
      <div>
        <div class="component-name">${name}</div>
        <div class="component-spec">${spec}</div>
      </div>
      <div class="component-qty">×${data.count}</div>
    `;
    item.addEventListener('mouseenter', () => highlightComponent(name, true));
    item.addEventListener('mouseleave', () => highlightComponent(name, false));
    item.addEventListener('click', () => focusComponent(name));
    list.appendChild(item);
  });
}

function getComponentSpec(name) {
  const W = state.width;
  const H = state.height;
  if (name.includes('Superior') || name.includes('Inferior')) return `${W} cm · Perfil 60mm`;
  if (name.includes('Jamba')) return `${H} cm · Perfil 60mm`;
  if (name.includes('Montante')) return `${H} cm · Perfil 42mm`;
  if (name.includes('Vidrio') || name.includes('Hoja')) return `${state.glass}mm · ${W}×${H}cm`;
  if (name.includes('Manija')) return 'Aluminio · 120mm';
  if (name.includes('Riel')) return `${W} cm · Aluminio`;
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
  const typeLabel = { fijo:'Fijo', '1hoja':'1 Hoja', '2hojas':'2 Hojas', '3hojas':'3 Hojas', '4hojas':'4 Hojas', corrediza:'Corrediza' }[state.type];
  document.getElementById('infoArea').textContent = area.toFixed(2) + ' m²';
  document.getElementById('infoPerim').textContent = perim.toFixed(2) + ' m';
  document.getElementById('infoWeight').textContent = weight + ' kg';
  document.getElementById('infoType').textContent = typeLabel;
}
