#!/usr/bin/env node
/**
 * Gera jardine/img/manifest.json a partir das pastas em jardine/img/
 * Rodar após pdf-to-images.sh
 */
const fs = require('fs');
const path = require('path');

const siteDir = path.join(__dirname, '..', 'jardine');
const imgDir = path.join(siteDir, 'img');

function listPngs(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir)
    .filter((f) => f.endsWith('.png'))
    .sort()
    .map((f) => path.relative(siteDir, path.join(dir, f)).replace(/\\/g, '/'));
}

const manifest = {
  apresentacao: listPngs(path.join(imgDir, 'apresentacao')),
  plantasApartamentos: [
    { id: 'localizacao', legenda: 'Localização', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'localizacao')) },
    { id: 'tipo-01', legenda: 'Tipo 01', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-01')) },
    { id: 'tipo-02', legenda: 'Tipo 02', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-02')) },
    { id: 'tipo-03', legenda: 'Tipo 03', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-03')) },
    { id: 'tipo-04', legenda: 'Tipo 04', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-04')) },
    { id: 'tipo-05', legenda: 'Tipo 05', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-05')) },
    { id: 'tipo-06', legenda: 'Tipo 06', imgs: listPngs(path.join(imgDir, 'plantas-apartamentos', 'tipo-06')) },
  ],
  plantasLazer: [
    { id: 'g5', legenda: 'Planta Baixa G5', imgs: listPngs(path.join(imgDir, 'plantas-lazer', 'g5')) },
    { id: 'rft', legenda: 'Planta Baixa RFT', imgs: listPngs(path.join(imgDir, 'plantas-lazer', 'rft')) },
  ],
};

const outPath = path.join(imgDir, 'manifest.json');
fs.writeFileSync(outPath, JSON.stringify(manifest, null, 2), 'utf8');
console.log('Manifest escrito em', outPath);
