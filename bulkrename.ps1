foreach ($thing in ls) {
    echo $thing.name >> tmp1
}

cp tmp1 tmp2

vim tmp2

$oldNames = get-content tmp1
$newNames = get-content tmp2

if ($oldNames.length -eq $newNames.length) {
    for ($i=0;$i-lt$oldNames.length;$i++) {
        try {
            mv $oldNames[$i] "t3Mp$i" -errorAction stop
        }
        catch {
            echo "Unable to rename $($oldNames[$i]) to $($newNames[$i]) due to the following error:"
            echo $_.Exception.Message
        }
    }
    for ($i=0;$i-lt$oldNames.length;$i++) {
        try {
            mv "t3Mp$i" $newNames[$i] -errorAction stop
        }
        catch {
            echo "Unable to rename $($oldNames[$i]) to $($newNames[$i]) due to the following error:"
            echo $_.Exception.Message
        }
    }
}

else {
    echo "Error: Incorrect number of new names"
}

rm *~
rm tmp*
