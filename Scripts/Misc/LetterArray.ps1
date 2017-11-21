# Create an array with A-Z
$alph=@()
65..90 | foreach-object { 
    $alph += [char]$_
}