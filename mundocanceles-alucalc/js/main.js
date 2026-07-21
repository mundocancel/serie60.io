document.addEventListener('DOMContentLoaded', () => {
  import('./scene.js').then(async ({ scene, camera, renderer, controls }) => {
    const { setupKeyboardControls } = await import('./controls.js');
    const { buildWindow } = await import('./window-builder.js');
    const { updateLabels } = await import('./labels.js');
    const { updateInfo } = await import('./components.js');
    const { setupUI, updateModeIndicator } = await import('./ui-handlers.js');
    const { animateOverlays, updateFPS } = await import('./animation.js');

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
  });
});
