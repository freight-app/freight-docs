#!/usr/bin/env node
import { readdir, mkdir } from 'node:fs/promises';
import { spawn } from 'node:child_process';
import { dirname, join, basename } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const diagramDir = join(root, 'diagrams');
const outDir = join(root, 'static', 'img', 'diagrams');

function run(cmd, args) {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, { cwd: root, stdio: 'inherit' });
    child.on('error', reject);
    child.on('exit', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`${cmd} ${args.join(' ')} exited with ${code}`));
      }
    });
  });
}

await mkdir(outDir, { recursive: true });
const files = (await readdir(diagramDir))
  .filter((file) => file.endsWith('.mmd'))
  .sort();

for (const file of files) {
  const input = join(diagramDir, file);
  const output = join(outDir, `${basename(file, '.mmd')}.svg`);
  await run('npx', [
    '-y',
    '@mermaid-js/mermaid-cli',
    '-i',
    input,
    '-o',
    output,
    '--backgroundColor',
    'transparent',
    '--theme',
    'dark',
  ]);
}
