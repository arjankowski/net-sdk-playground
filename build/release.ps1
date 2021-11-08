Param
(
    #[Parameter(Mandatory)]
    [Alias('dr')]
    [bool]$DryRun = $true,

    #[Parameter(Mandatory)]
    [Alias('gh')]
    [string]$GithubToken,

    #[Parameter(Mandatory)]
    [Alias('ng')]
    [string]$NugetKey
)

$ErrorActionPreference = "Stop"
#.\build\release.ps1
$ROOT_DIR=$pwd
$CHANGELOG_PATH="$ROOT_DIR" + "\CHANGELOG.md"
$SLN_PATH="$ROOT_DIR" + "\Net.Sdk.Playground.sln"
$FRAMEWORK_PROJ_DIR="$ROOT_DIR" + "\Net.Sdk.Playground"
$CORE_PROJ_DIR="$ROOT_DIR" + "\Net.Sdk.Playground.Core"
$TEST_PROJ_DIR="$ROOT_DIR" + "\Net.Sdk.Playground.Test"
$NET_CORE_VER="netcoreapp2.0"
$NET_FRAMEWORK_VER="net45"
$FRAMEWORK_DLL_PATH="$ROOT_DIR" + "\Net.Sdk.Playground\bin\Release\Net.Sdk.Playground.dll"
$NET_CORE_CSPROJ_PATH="$CORE_PROJ_DIR" + "\Net.Sdk.Playground.Core.csproj"
$ASSEMBLYINFO_PATH="$FRAMEWORK_PROJ_DIR" + "\Utility\AssemblyInfo.cs"
$NET_FRAMEWORK_NUSPEC_PATH="$FRAMEWORK_PROJ_DIR" + "\Net.Sdk.Playground.nuspec"
$REPO_OWNER="mwwoda"
$REPO_NAME="net-sdk-playground"
$NUGET_URL="https://api.nuget.org/v3/index.json"

###########################################################################
# Install dependencies
###########################################################################

#curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
#sudo apt-get install -y nodejs
#sudo npm install -g standard-version
#setup sn.exe path
#setup msbuild and dotnet sdk
#Install-Module -Name PowerShellForGitHub

###########################################################################
# Ensure git tree is clean
###########################################################################

#exit 0
if (git status --porcelain) { echo "Not clean" }

###########################################################################
# Build and Test Framework
###########################################################################

# dotnet clean $FRAMEWORK_PROJ_DIR
# if (test-path ("$FRAMEWORK_PROJ_DIR" + "\bin")) { rm ("$FRAMEWORK_PROJ_DIR" + "\bin") -r }
# if (test-path ("$FRAMEWORK_PROJ_DIR" + "\obj")) { rm ("$FRAMEWORK_PROJ_DIR" + "\obj") -r }
# # dotnet build $FRAMEWORK_PROJ_DIR
# # dotnet test -f $NET_FRAMEWORK_VER
# # dotnet clean $FRAMEWORK_PROJ_DIR
# if (test-path ("$FRAMEWORK_PROJ_DIR" + "\bin")) { rm ("$FRAMEWORK_PROJ_DIR" + "\bin") -r }
# if (test-path ("$FRAMEWORK_PROJ_DIR" + "\obj")) { rm ("$FRAMEWORK_PROJ_DIR" + "\obj") -r }

###########################################################################
# Build and Test Core
###########################################################################

# dotnet clean $CORE_PROJ_DIR
# if (test-path ("$CORE_PROJ_DIR" + "\bin")) { rm ("$CORE_PROJ_DIR" + "\bin") -r }
# if (test-path ("$CORE_PROJ_DIR" + "\obj")) { rm ("$CORE_PROJ_DIR" + "\obj") -r }
# # dotnet build $CORE_PROJ_DIR
# # dotnet test -f $NET_CORE_VER
# # dotnet clean $CORE_PROJ_DIR
# dir ("$CORE_PROJ_DIR" + "\bin") -ErrorAction SilentlyContinue  | Remove-Item -Recurse
# dir ("$CORE_PROJ_DIR" + "\obj") -ErrorAction SilentlyContinue  | Remove-Item -Recurse

###########################################################################
# Pack Framework
###########################################################################

# msbuild.exe $FRAMEWORK_PROJ_DIR /property:Configuration=Release

###########################################################################
# Pack Core
###########################################################################

# dotnet pack $CORE_PROJ_DIR -c Release

###########################################################################
# Validate Framework signature
###########################################################################

# sn -v $FRAMEWORK_DLL_PATH

###########################################################################
# Publish Framework to nuget
###########################################################################

dotnet nuget push foo.nupkg -k $NugetKey -s $NugetKey

###########################################################################
# Publish Core to nuget
###########################################################################

dotnet nuget push foo.nupkg -k $NugetKey -s $NugetKey

###########################################################################
# Create git release
###########################################################################

# $password = ConvertTo-SecureString "$GithubToken" -AsPlainText -Force
# $Cred = New-Object System.Management.Automation.PSCredential ("Release_Bot", $password)
# Set-GitHubAuthentication -SessionOnly -Credential $Cred
# New-GitHubRelease -OwnerName $REPO_OWNER -RepositoryName $REPO_NAME -Tag $NEXT_VERSION_TAG -Name $NEXT_VERSION_TAG -Body "Release notes"
# echo $issues
# Clear-GitHubAuthentication

echo "DONE"
