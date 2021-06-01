# Intro - PowerShell is an object-oriented scripting language written in the most part in C#. Orignailly called monad, it was developed by Jeffrey Snover (Chief Architect for PowerShell) in early 2003. Snover was also chief architect for MMC, but lets not hold that agains him :).
# Powershell (5.1)- Windows only - Build on the .Net Framework
# Powershell Core (6)- Multiplatform - built on .Net Core

# By convention, we name variables in camelCase. Functions and paramters are typically PascalCase.


## Scalar Values i.e Single value
# Int and performing calculations

$a = 1
$b = 2

# By default, PowerShell will return this to STDOUT, errors and exceptions are sent to STDERR ($error)

$a + $b
$a - $b
$a * $b
$a / $b
$a % $b

## Strings

$string = "String"
$string
$string = 'This is also a string'
$string
$string = '"This is a quoted string"' 
$string

## Strings can be added / concatenated together
$hello = "Hello"
$world = "World"
$helloWorld = $hello + $world
$helloWorld

## String Interpolation - Sometimes we need to output other objects to the screen. Typically, we can just add the var to the string output as below
$mostHandles = (Get-Process | Sort-Object Handles -Desc)[0]
## This will not output correctly, since we are trying to acces the property of the object
"Process with the most handles is $mostHandles.ProcessName"
## We need to use string interpolation to ensure the output is correct
"Process with the most handles is $($mostHandles.ProcessName)"

## Here Strings - This is a multi line string
$hereString = @'
This 
string
extends
multiple
lines
'@

$hereString

# Arrays and Collections
# Arrays - This is a fixed length array

$array = @("Item1","Item2","Item3")
$array.GetType()

## we can also declare on multiple lines, for readability - Note Commas are not required here

$array = @(
    "Item1"
    "Item2"
    "Item3"
)

$array

# If we try to add to this list we will get a exception - Exception calling "Add" with "1" argument(s): "Collection was of a fixed size."
# Arrays are created with a fixed size

$array.add("Item4")

# We must use the += operator. This is an an expensive operation, especially when adding hundreds or thousands of items are added to the array. 
# The entire array must be re-written on each += operation, and the time take to complete the operation will increase exponentially to the number of objects in the array
# We will discuss an alternative, more efficient, way to do this later. 

$array += ("Item4")
$array += (4)

# Array with ranges - this is a short way to create an array with a range of numbers

$arrayRange = 0..20
$arrayRange

# Selecting objects from the array with index value
$arrayRange[0]
$arrayRange[20]

## Looping through an array
# Call the ForEach Method
$arrayRange.ForEach({
    Write-Host -ForegroundColor Red -Object $_
})
# Pipe to ForEach-Object - Passes each item through the pipeline sequentially
$arrayRange | ForEach-Object {
    Write-Host -ForegroundColor Green -Object $_
}
# ForEach Statement - Loads the whole array into memory. 
foreach ($number in $arrayRange){
    Write-Host -ForegroundColor Red -Object $number
}

## Hashtables can be quicker than arrays for searching larger data sets. They data in a hash map often refered to as key / value pair

$hashtable = @{
    "Forename" = "Scott"
    "Surname" = "Gray"
}

$hashtable
$hashTable.Forename

$hashtable.Add("Age", 27)
$hashTable.Age

## We can also use nested hashtables

$thisIsAHashTable = @{
    "VDA-1" = @{
        "Status" = "Online"
        "Registration" = "Registered"
    }
    "VDA-2" = @{
        "Status" = "Online"
        "Registration" = "Registered"
    }
}
$thisIsAHashTable.GetType()
$thisIsAHashTable
$computer3Status =  @{
        "Status" = "Offline"
        "Registration" = "Unregistered"
    }

## We can add a key value pair easily
$thisIsAHashTable.Add("VDA-3", $computer3Status)

$thisIsAHashTable.'VDA-3'
$thisIsAHashTable.'VDA-3'.Status

$thisIsAHashTable.'VDA-3'.Status = "Online"
$thisIsAHashTable.'VDA-3'.Registration = "Registered"
$thisIsAHashTable.'VDA-3'

## We can also remove the entry if is not needed 
if($thisIsAHashTable.Keys.Where({$_ -EQ "VDA-3"})){
    Write-Host "VDA-3 found - Removing" -ForegroundColor Red
    $thisIsAHashTable.Remove("VDA-3")
    Write-Host "VDA-3 Removed" -ForegroundColor Green
    $thisIsAHashTable
}

# Since PowerShell is written around .Net, we have access to .Net type accelerators. 

$time = [datetime]::Now
#          ^          ^
#         Type      Property
$time
# We can also call methods
$daysInJune =  [datetime]::DaysInMonth(2021,6)
#                  ^            ^        ^
#                Type         Method    Args
$daysInJune

# When working with large quantities of objects, we are best using either an ArrayList or generic List<T>, rather than System.Array i.e. @() - A generic is a type which accepts multiple other types as the input, for example we could have a list of type string List<string> or a custom type List<Customer>
# Generics are more of an advanced topic and may be covered in another session

$arrayList = [System.Collections.ArrayList]@("Item1", "Item2", "Item3")

$arrayList.Add("Item4")

# Notice that by design, the add method returns the index at which the item was created, in this case 3
# In most cases, this is not a desired and so can be re-directed to $null using one of the following options

$null = $arrayList.Add("Item5")
$arrayList.Add("Item6") | Out-Null

# Filtering objects with Where, and Where-Object

$events = Get-EventLog -LogName Application -Newest 100
$events[0] | Get-Member -MemberType Property

$events.where({$_.EntryType -EQ "Error"})

$events | Where-Object {
    $_.EntryType -EQ "Error"
}

