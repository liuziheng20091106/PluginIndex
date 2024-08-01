param($inputPath,$outputPath,$basePath,$customClassIslandPath)

function Wait-Task {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Threading.Tasks.Task[]]$Task
    )

    Begin {
        $Tasks = @()
    }

    Process {
        $Tasks += $Task
    }

    End {
        While (-not [System.Threading.Tasks.Task]::WaitAll($Tasks, 200)) {}
        $Tasks.ForEach( { $_.GetAwaiter().GetResult() })
    }
}

Set-Alias -Name await -Value Wait-Task -Force

# TODO: 从 AppVeyor 下载 ClassIsland 实例

Import-Module $customClassIslandPath

await ([ClassIsland.Core.Helpers.PluginMarketHelper]::GeneratePluginIndexFromManifests($inputPath, $outputPath, $basePath))
