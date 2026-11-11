# The folder builder sets BAY_TEMPLATES so sources can live anywhere.
use Cwd qw(abs_path);
my $templates = abs_path($ENV{'BAY_TEMPLATES'} // '.');
$ENV{'TEXINPUTS'} = "$templates/stylesheets//:$templates/vendor/xlistings//:" . ($ENV{'TEXINPUTS'} // '');
$ENV{'TTFONTS'} = "$templates/vendor/firacode//:" . ($ENV{'TTFONTS'} // '');
$out_dir = 'build';
$pdf_mode = 1;
