import * as THREE from 'three';
import { state } from './state.js';

export const glassMaterial = new THREE.MeshPhysicalMaterial({
  color: 0x99B3CC,
  metalness: 0,
  roughness: 0.02,
  transmission: 0.96,
  thickness: 0.5,
  ior: 1.52,
  clearcoat: 1.0,
  clearcoatRoughness: 0.05,
  transparent: true,
  attenuationColor: new THREE.Color(0xAACCEE),
  attenuationDistance: 0.5,
  envMapIntensity: 1.0,
  side: THREE.DoubleSide
});

export const frameMaterial = new THREE.MeshPhysicalMaterial({
  color: state.color,
  metalness: 0.85,
  roughness: 0.25,
  clearcoat: 0.6,
  clearcoatRoughness: 0.15,
  envMapIntensity: 1.5
});

export const handleMaterial = new THREE.MeshPhysicalMaterial({
  color: 0x333333,
  metalness: 0.95,
  roughness: 0.15,
  clearcoat: 0.8,
  clearcoatRoughness: 0.1,
  envMapIntensity: 1.5
});

export const floorMat = new THREE.MeshStandardMaterial({
  color: 0xd8dde5,
  roughness: 0.8,
  metalness: 0.1
});
