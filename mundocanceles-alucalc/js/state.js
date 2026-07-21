export const state = {
  width: 120,
  height: 140,
  glass: 6,
  color: 0xE8E8E8,
  type: 'fijo',
  exploded: false,
  showLabels: false,
  showDimensions: true,
  viewMode: '3d'
};

export const typeLabels = {
  fijo: 'Fijo',
  '1hoja': '1 Hoja',
  '2hojas': '2 Hojas',
  corrediza: 'Corrediza'
};

export const FRAME_PROFILE = 0.06;
export const FRAME_DEPTH = 0.08;

export function meters(cm) {
  return cm / 100;
}

export const components = [];
