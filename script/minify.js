const program = require('commander');
const compressor = require('node-minify');

program
  .option('--input [value]', 'input file path')
  .option('--output [value]', 'output file path')
  .option('--compressor [value]', 'compressor')
  .parse(process.argv);

process.stderr.write(program.input + '\n');
process.stderr.write(program.output + '\n');
process.stderr.write(program.compressor + '\n');

compressor.minify({
  compressor: program.compressor,
  input: program.input,
  output: program.output,
  callback: function (err, min) {
    if (err) {
      process.exit(1);
    }
  }
});
