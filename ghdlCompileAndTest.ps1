<#
.SYNOPSIS
    Compile VHDL sources with GHDL and run simulations (single or multiple testbenches).

.EXAMPLE
    .\ghdlCompileAndTest.ps1 -SrcDir .\src -TestDir .\tests -Top tb_mydesign -StopTime 1us -Wave out.ghw

.PARAMETER SrcDir
    Directory with project VHDL sources (default: .\src).

.PARAMETER TestDir
    Directory with testbench VHDL files (default: .\tests).

.PARAMETER Top
    Top-level testbench entity name. If omitted, script will try to run all *_tb.vhd files found.

.PARAMETER StopTime
    Simulation stop time passed to GHDL via --stop-time (e.g. 100ns, 1us). Optional.

.PARAMETER Wave
    Waveform output file (VCD or GHW). If omitted no waveform is produced.

.PARAMETER Clean
    If present, remove previous GHDL work files before compiling.

.PARAMETER RunArgs
    Additional arguments to pass to ghdl -r.

#>

param(
        [string]$SrcDir = ".\src",
        [string]$TestDir = ".\tests",
        [string]$Top = "",
        [string]$StopTime = "",
        [string]$Wave = "",
        [switch]$Clean,
        [string]$RunArgs = ""
)

function Fail($msg) {
        Write-Error $msg
        exit 1
}

# Ensure ghdl is available
if (-not (Get-Command ghdl -ErrorAction SilentlyContinue)) {
        Fail "ghdl executable not found in PATH. Install GHDL and add to PATH."
}

# Normalize paths
$SrcDir = Resolve-Path -LiteralPath $SrcDir -ErrorAction SilentlyContinue
$TestDir = Resolve-Path -LiteralPath $TestDir -ErrorAction SilentlyContinue

if (-not $SrcDir) { Fail "Source directory '$($SrcDir)' not found." }
if (-not $TestDir) { Write-Verbose "Test directory not found; continuing if Top specified." }

# Optional clean
if ($Clean) {
        Write-Host "Cleaning previous GHDL files..."
        ghdl --clean --workdir=work
        if ($LASTEXITCODE -ne 0) { Fail "ghdl --clean failed." }
}

# Compile sources
Write-Host "Analyzing sources in $SrcDir..."
Get-ChildItem -Path $SrcDir -Filter *.vhd -Recurse -File | ForEach-Object {
        Write-Host "  ghdl -a --std=08 -fsynopsys $_"
        ghdl -a --std=08 -fsynopsys $_.FullName
        if ($LASTEXITCODE -ne 0) { Fail "Analysis failed for $($_.FullName)" }
}

# Compile testbenches
$tbFiles = @()
if ($Top) {
        # User specified top; analyze all .vhd/.vhdl files in current directory to include testbench
        $tbFiles = Get-ChildItem -Path "." -Include *.vhd,*.vhdl -File -ErrorAction SilentlyContinue
        foreach ($f in $tbFiles) {
                Write-Host "  ghdl -a --std=08 -fsynopsys $($f.FullName)"
                ghdl -a --std=08 -fsynopsys $f.FullName
                if ($LASTEXITCODE -ne 0) { Fail "Analysis failed for $($f.FullName)" }
        }
} else {
        # Discover testbenches by convention *_tb.vhd or *tb.vhd
        $tbFiles = Get-ChildItem -Path $TestDir -Include '*_tb.vhd','*tb.vhd' -Recurse -File -ErrorAction SilentlyContinue
        if (-not $tbFiles -or $tbFiles.Count -eq 0) {
                Fail "No testbench files found in '$TestDir'. Provide -Top or add *_tb.vhd files."
        }
        foreach ($f in $tbFiles) {
                Write-Host "  ghdl -a --std=08 -fsynopsys $($f.FullName)"
                ghdl -a --std=08 -fsynopsys $f.FullName
                if ($LASTEXITCODE -ne 0) { Fail "Analysis failed for $($f.FullName)" }
        }
}

# Determine top-levels to run
$topsToRun = @()
if ($Top) {
        # Allow user to pass either an entity name or a file path (e.g. .\testbench.vhdl)
        if ($Top -match '[\\/]' -or $Top -match '\.vhd$|\.vhdl$') {
                $origTop = $Top
                $Top = [System.IO.Path]::GetFileNameWithoutExtension($Top)
                Write-Host "Normalized -Top to entity name '$Top' from '$origTop'."
        }
        $topsToRun += $Top
} else {
        # extract entity names from file basenames (common convention)
        foreach ($f in $tbFiles) {
                $name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)
                $topsToRun += $name
        }
}

# Run simulations
foreach ($topEnt in $topsToRun) {
        Write-Host "Elaborating and running '$topEnt'..."
        # Elaborate (optional, ghdl -r does that implicitly but explicit -e can be useful)
        ghdl -e --std=08 -fsynopsys $topEnt 2>$null
        if ($LASTEXITCODE -ne 0) {
                # ghdl -e may fail if the binary name differs from entity; ignore and try -r directly
                Write-Verbose "ghdl -e failed for $topEnt; will try ghdl -r anyway."
        }

        $runCmd = "ghdl -r --std=08 -fsynopsys $topEnt"
        if ($StopTime) { $runCmd += " --stop-time=$StopTime" }
        if ($Wave) {
                # choose option by extension: .vcd => --vcd, .ghw/.ghwt/.fst => --wave/--fst
                $ext = [System.IO.Path]::GetExtension($Wave).ToLower()
                switch ($ext) {
                        ".vcd" { $runCmd += " --vcd=$Wave" }
                        ".ghw" { $runCmd += " --wave=$Wave" }
                        ".fst" { $runCmd += " --fst=$Wave" }
                        default { $runCmd += " --vcd=$Wave" }
                }
        }
        if ($RunArgs) { $runCmd += " $RunArgs" }

        Write-Host "  $runCmd"
        iex $runCmd
        if ($LASTEXITCODE -ne 0) {
                Fail "Simulation failed for $topEnt"
        } else {
                Write-Host "Simulation of $topEnt completed."
        }
}

Write-Host "All done."