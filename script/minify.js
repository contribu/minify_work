const program = require('commander');
const compressor = require('node-minify');

program
  .option('--input', 'input file path')
  .option('--compressor', 'compressor')
  .parse(process.argv);

compressor.minify({
  compressor: program.compressor,
  input: program.input,
  callback: function (err, min) {
    if (err) {
      process.stderr.write(err);
      process.exit(1);
    } else {
      process.stdout.write(min);
    }
  }
});
