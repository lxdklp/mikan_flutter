import esbuild from 'esbuild';

const isWatch = process.argv.includes('--watch');

const config = {
  entryPoints: ['src/index.ts'],
  bundle: true,
  format: 'esm',
  target: 'ES2020',
  outfile: '../assets/js/api.js',
  minify: true,
  logLevel: 'info',
  platform: 'browser',
  external: [],
  define: {
    'process.env.NODE_ENV': '"production"'
  },
};

if (isWatch) {
  (async () => {
    const ctx = await esbuild.context(config);
    await ctx.watch();
    console.log('👀 Watching for changes...');
  })();
} else {
  (async () => {
    await esbuild.build(config);
    console.log('✅ Build complete: ../assets/js/api.js');
  })();
}
