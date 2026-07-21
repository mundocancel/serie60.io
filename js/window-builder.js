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

  windowGroup.add(createFramePiece(W + fp, fp, fd, new THREE.Vector3(0, H/2 + fp/2, 0), 'Marco Superior', new THREE.Vector3(0, 0.4, 0)));
  windowGroup.add(createFramePiece(W + fp, fp, fd, new THREE.Vector3(0, -H/2 - fp/2, 0), 'Marco Inferior', new THREE.Vector3(0, -0.4, 0)));
  windowGroup.add(createFramePiece(fp, H + fp, fd, new THREE.Vector3(-W/2 - fp/2, 0, 0), 'Jamba Izquierda', new THREE.Vector3(-0.4, 0, 0)));
  windowGroup.add(createFramePiece(fp, H + fp, fd, new THREE.Vector3(W/2 + fp/2, 0, 0), 'Jamba Derecha', new THREE.Vector3(0.4, 0, 0)));

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
  } else if (state.type === '3hojas') {
    windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(-W * 0.16, 0, 0), 'Montante 1', new THREE.Vector3(-0.3, 0, 0.3)));
    windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(W * 0.16, 0, 0), 'Montante 2', new THREE.Vector3(0.3, 0, 0.3)));
    const pw3 = (W - fp * 0.7 * 2) / 3;
    windowGroup.add(createGlassPane(pw3, H - 0.02, glassThickness, new THREE.Vector3(-W * 0.22, 0, 0), 'Hoja 1', new THREE.Vector3(-0.35, 0, 0.5)));
    windowGroup.add(createGlassPane(pw3, H - 0.02, glassThickness, new THREE.Vector3(0, 0, 0), 'Hoja 2', new THREE.Vector3(0, 0, 0.5)));
    windowGroup.add(createGlassPane(pw3, H - 0.02, glassThickness, new THREE.Vector3(W * 0.22, 0, 0), 'Hoja 3', new THREE.Vector3(0.35, 0, 0.5)));
    windowGroup.add(createHandle(new THREE.Vector3(-W * 0.22 + pw3/2, 0, fd/2 + 0.02), 'Manija 1', new THREE.Vector3(-0.2, 0, 0.4)));
    windowGroup.add(createHandle(new THREE.Vector3(W * 0.22 - pw3/2, 0, fd/2 + 0.02), 'Manija 3', new THREE.Vector3(0.2, 0, 0.4)));
  } else if (state.type === '4hojas') {
    windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(-W * 0.2, 0, 0), 'Montante 1', new THREE.Vector3(-0.35, 0, 0.3)));
    windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(0, 0, 0), 'Montante 2', new THREE.Vector3(0, 0, 0.3)));
    windowGroup.add(createFramePiece(fp * 0.7, H, fd, new THREE.Vector3(W * 0.2, 0, 0), 'Montante 3', new THREE.Vector3(0.35, 0, 0.3)));
    const pw4 = (W - fp * 0.7 * 3) / 4;
    const x1 = -W * 0.325;
    const x2 = -W * 0.1125;
    const x3 = W * 0.1125;
    const x4 = W * 0.325;
    windowGroup.add(createGlassPane(pw4, H - 0.02, glassThickness, new THREE.Vector3(x1, 0, 0), 'Hoja 1', new THREE.Vector3(-0.4, 0, 0.5)));
    windowGroup.add(createGlassPane(pw4, H - 0.02, glassThickness, new THREE.Vector3(x2, 0, 0), 'Hoja 2', new THREE.Vector3(-0.15, 0, 0.5)));
    windowGroup.add(createGlassPane(pw4, H - 0.02, glassThickness, new THREE.Vector3(x3, 0, 0), 'Hoja 3', new THREE.Vector3(0.15, 0, 0.5)));
    windowGroup.add(createGlassPane(pw4, H - 0.02, glassThickness, new THREE.Vector3(x4, 0, 0), 'Hoja 4', new THREE.Vector3(0.4, 0, 0.5)));
    windowGroup.add(createHandle(new THREE.Vector3(x1 + pw4/2, 0, fd/2 + 0.02), 'Manija 1', new THREE.Vector3(-0.25, 0, 0.4)));
    windowGroup.add(createHandle(new THREE.Vector3(x2 + pw4/2, 0, fd/2 + 0.02), 'Manija 2', new THREE.Vector3(-0.1, 0, 0.4)));
    windowGroup.add(createHandle(new THREE.Vector3(x3 + pw4/2, 0, fd/2 + 0.02), 'Manija 3', new THREE.Vector3(0.1, 0, 0.4)));
    windowGroup.add(createHandle(new THREE.Vector3(x4 + pw4/2, 0, fd/2 + 0.02), 'Manija 4', new THREE.Vector3(0.25, 0, 0.4)));
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
}
