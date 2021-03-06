#############################################################################
#
#  Copyright 2013 Electric-Cloud Inc.
#
#############################################################################
use File::Path;

$[/myProject/scripts/perlHeaderJSON]

$DEBUG=1;

# Parameters
#
my $path='$[pathname]';

my $errorCount=0;
my $groupCount=0;

# Get list of Project
my ($success, $xPath) = InvokeCommander("SuppressLog", "getGroups", {maximum=>5000});

# Create the Resources directory
mkpath("$path/groups");
chmod(0777, "$path/groups");

foreach my $node ($xPath->findnodes('//group')) {
  my $groupName=$node->{'groupName'};

  printf("Saving group: %s\n", $groupName);
  my $fileGroupName=safeFilename($groupName); 
  
  my ($success, $res, $errMsg, $errCode) = 
      InvokeCommander("SuppressLog", "export", "$path/groups/$fileGroupName".".xml",
  					{ 'path'=> "/groups/".$groupName, 
                                          'relocatable' => 1,
                                          'withAcls'    => 1});
  if (! $success) {
    printf("  Error exporting %s", $groupName);
    printf("  %s: %s\n", $errCode, $errMsg);
    $errorCount++;
  } else {
    $groupCount++;
  }
}
$ec->setProperty("preSummary", "$groupCount groups exported");
exit($errorCount);

#
# Make the name of an object safe to be a file or directory name
#
sub safeFilename {
  my $safe=@_[0];
  $safe =~ s#[\*\.\"/\[\]\\:;,=\|]#_#g;
  return $safe;
}


$[/myProject/scripts/perlLibJSON]


