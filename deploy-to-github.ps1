param(
  [string]$Owner = "zhuolingcheng",
  [string]$Repo = "data-management-platform",
  [string]$Branch = "main",
  [string]$DeployDir = "$PSScriptRoot\github-pages-deploy",
  [string]$Message = "Update data management platform"
)

$ErrorActionPreference = "Stop"

if (-not $env:GITHUB_TOKEN) {
  throw "Missing environment variable GITHUB_TOKEN. Set it before running this script."
}

if (-not (Test-Path -LiteralPath $DeployDir)) {
  throw "Deploy directory does not exist: $DeployDir"
}

$headers = @{
  Authorization = "Bearer $env:GITHUB_TOKEN"
  Accept = "application/vnd.github+json"
  "X-GitHub-Api-Version" = "2022-11-28"
}

function ConvertTo-GitHubPath {
  param([string]$Path)
  return (($Path -split "[\\/]+") | ForEach-Object { [uri]::EscapeDataString($_) }) -join "/"
}

$files = Get-ChildItem -LiteralPath $DeployDir -File -Recurse
foreach ($file in $files) {
  $relative = $file.FullName.Substring((Resolve-Path -LiteralPath $DeployDir).Path.Length).TrimStart([char]92, [char]47)
  $githubPath = ConvertTo-GitHubPath $relative
  $url = "https://api.github.com/repos/$Owner/$Repo/contents/$githubPath"

  $sha = $null
  try {
    $existing = Invoke-RestMethod -Method Get -Uri "${url}?ref=$Branch" -Headers $headers
    $sha = $existing.sha
  } catch {
    if ($_.Exception.Response.StatusCode.value__ -ne 404) { throw }
  }

  $content = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))
  $body = @{
    message = "$Message - $relative"
    content = $content
    branch = $Branch
  }
  if ($sha) { $body.sha = $sha }

  Invoke-RestMethod -Method Put -Uri $url -Headers $headers -Body ($body | ConvertTo-Json) -ContentType "application/json" | Out-Null
  Write-Host "uploaded $relative"
}

Write-Host "done: https://$Owner.github.io/$Repo/"
