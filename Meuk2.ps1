$menu = Get-Content .\menu.json | ConvertFrom-Json 
$correctOrder = 'n'

while($correctOrder -ne 'y'){
    $gerechtId = ''
    $orderList = @()
    while ($gerechtId -ne 'done'){
        Write-Output $menu | Out-Host
        $gerechtId = Read-Host -Prompt "Input the dish id you would like to add to your order, type 'done' if your order is complete "
        if($menu.id -contains $gerechtId -ne $true -And $gerechtId -ne 'done'){
            Write-Host "The id you entered is not existent" 
        }elseif($menu.id -contains $gerechtId){
            $orderList += $menu[$menu.id.IndexOf([int]$gerechtId)]
        }
    }
    
    $DistinctList = $orderList | Group-Object id  
    $Distinct =foreach($distinctOrder in $DistinctList){
    $Data = $orderList | where id -eq $distinctOrder.Name
    $Price = ($Data.Price|Measure -Sum).sum
    $Dish = $Data.Dish | select -First 1
    [PSCustomObject]@{
        'Count' = $distinctOrder.Count
        'Id' = $distinctOrder.Name
        'Dish' = $Dish
        'Price' = $Price
    }
    }

    Write-Output "Your order is"  $Distinct |Out-Host
    $correctOrder = Read-Host -Prompt "Is your order correct y/n"
    while($correctOrder -ne 'y' -and $correctOrder -ne 'n'){
        $correctOrder = Read-Host -Prompt "Is your order correct y/n"
    }
}

$totalPrice = 0
foreach ($price in $orderList.Price){
    $totalPrice = $totalPrice + $price
}

Write-Output "Your total amount is $totalPrice" 
