# The folder builder sets BAY_TEMPLATES so sources can live anywhere.
use Cwd qw(abs_path);
my $templates = abs_path($ENV{'BAY_TEMPLATES'} // '.');
my $path_separator = $^O eq 'MSWin32' ? ';' : ':';
$ENV{'TEXINPUTS'} = join($path_separator, "$templates/stylesheets//", "$templates/vendor/xlistings//", $ENV{'TEXINPUTS'} // '');
$ENV{'TTFONTS'} = join($path_separator, "$templates/vendor/firacode//", $ENV{'TTFONTS'} // '');
$out_dir = 'build';
$pdf_mode = 1;
