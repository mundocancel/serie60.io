import { components } from './state.js';
import { positionLabels, update3DLabels } from './labels.js';
import { drawDimensionLines } from './dimensions.js';
import { explodeCurrent, explodeTarget } from './ui-handlers.js';

export function animateOverlays() {
  const delta = explodeTarget - explodeCurrent;
  if (Math.abs(delta) < 0.001) {
    explodeCurrent = explodeTarget;
  } else {
    explodeCurrent += delta * 0.08;
  }

  components.forEach(c => {
    if (c.userData.basePosition && c.userData.explodeOffset) {
      const target = c.userData.explodeOffset.clone().multiplyScalar(explodeCurrent);
      c.position.copy(c.userData.basePosition).add(target);
    }
  });

  positionLabels();
  drawDimensionLines();
  update3DLabels();
}

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
