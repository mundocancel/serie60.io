import { scene, camera, renderer, controls } from './scene.js';
import { setupKeyboardControls } from './controls.js';
import { buildWindow } from './window-builder.js';
import { updateLabels } from './labels.js';
import { updateInfo } from './components.js';
import { setupUI, updateModeIndicator } from './ui-handlers.js';
import { animateOverlays, updateFPS } from './animation.js';

setupUI();
setupKeyboardControls(document.getElementById('canvas3d'));

buildWindow();
updateLabels();
updateInfo();
updateModeIndicator();

setTimeout(() => {
  document.getElementById('loader').classList.add('hidden');
}, 600);

function animate() {
  requestAnimationFrame(animate);
  controls.update();
  animateOverlays();
  updateFPS();
  renderer.render(scene, camera);
}

animate();

setTimeout(() => document.getElementById('canvas3d').focus(), 700);

console.log('✅ MundoCanceles · ALUCALC Despiece Técnico inicializado');
