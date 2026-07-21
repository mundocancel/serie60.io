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
  
  const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
  line.setAttribute('x1', start.x); line.setAttribute('y1', start.y);
  line.setAttribute('x2', end.x); line.setAttribute('y2', end.y);
  line.setAttribute('stroke', '#ff6b35'); line.setAttribute('stroke-width', '1.5');
  line.classList.add('dim-line');
  svg.appendChild(line);

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
    poly.setAttribute('points', `${point.x},${point.y} ${p1.x},${p1.y} ${p2.x},${p2.y}`);
    poly.setAttribute('fill', '#ff6b35');
    poly.classList.add('dim-line');
    svg.appendChild(poly);
  });
}
