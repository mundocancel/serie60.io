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
