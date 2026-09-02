# diario.ps1 - diario de bordo no git (pequenas atualizacoes de progresso da task).
# Mantem uma TABELA enxuta em PROGRESSO-<task>.md (Quando | Etapa | Atualizacao) e, em modo repo,
# commita+pusha na branch squad/<task>, abre um PR/MR em rascunho (draft) na abertura e mantem a
# DESCRICAO do PR/MR com a mesma tabela. Fonte unica das regras:
# squad\_core\orquestracao\diario-de-bordo.md.
# Uso:
#   pwsh -File diario.ps1 -Task <id> -Marco <marco> -Resumo "<uma frase curta do que fez/vai fazer>" `
#        [-Repo <clone>] [-Branch squad/<task>] [-Base <branch alvo>] [-Titulo "<titulo>"] [-SemPR] [-SemPush]
# Marcos (viram a coluna Etapa): abertura | evento | fechamento (aliases: onda->Evento, review->Revisao,
#   qa->QA, bloqueio->Bloqueio). Qualquer outro texto vira a propria etapa.
# Modo repo: -Repo com .git + remote e -Branch squad/*. Sem isso = modo local (so escreve o arquivo).
# PR/MR e best-effort: exige gh (GitHub) ou glab (GitLab); sem eles, o arquivo na branch e o registro.
# Exit 0 = ok . Exit 1 = erro de uso/guarda
param(
    [Parameter(Mandatory = $true)][string]$Task,
    [Parameter(Mandatory = $true)][string]$Marco,
    [Parameter(Mandatory = $true)][string]$Resumo,
    [string]$Repo,
    [string]$Branch,
    [string]$Base,
    [string]$Titulo,
    [switch]$SemPR,
    [switch]$SemPush
)

$ErrorActionPreference = 'Stop'
$raiz = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$ini = '<!-- squad:diario -->'
$fim = '<!-- /squad:diario -->'

# UTF-8 SEM BOM na saida (o .ps1 e salvo COM BOM para o PS 5.1 ler os acentos das labels corretamente)
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
function Write-Txt([string]$path, [string]$txt) { [IO.File]::WriteAllText($path, $txt, $utf8NoBom) }
function Add-Txt([string]$path, [string]$txt) { [IO.File]::AppendAllText($path, $txt, $utf8NoBom) }

# marco -> rotulo amigavel da coluna Etapa
function Get-Etapa([string]$m) {
    switch ($m.ToLower()) {
        'abertura'   { 'Abertura';   break }
        'evento'     { 'Evento';     break }
        'onda'       { 'Evento';     break }
        'review'     { 'Revisão';    break }
        'qa'         { 'QA';         break }
        'bloqueio'   { 'Bloqueio';   break }
        'fechamento' { 'Fechamento'; break }
        default      { (Get-Culture).TextInfo.ToTitleCase($m.ToLower()) }
    }
}

$ts = Get-Date -Format 'yyyy-MM-dd HH:mm'
$etapa = Get-Etapa $Marco
$msg = ($Resumo -replace '\r?\n', ' ' -replace '\|', '\|').Trim()   # cabe numa celula da tabela
$linhaTab = "| $ts | $etapa | $msg |`n"

# monta o bloco gerenciado da DESCRICAO do PR/MR: a MESMA tabela do arquivo
function New-BlocoDescricao([string]$arq) {
    $rows = @()
    if (Test-Path $arq) { $rows = Get-Content $arq -Encoding UTF8 | Where-Object { $_ -match '^\|\s*\d{4}-' } }
    $b = @()
    $b += $ini
    $b += '### Diário de bordo — atualização em tempo real'
    $b += '| Quando | Etapa | Atualização |'
    $b += '| --- | --- | --- |'
    foreach ($r in $rows) { $b += $r }
    $b += ''
    $b += '_Rascunho (DRAFT) — o merge é do humano._'
    $b += $fim
    return ($b -join "`n")
}

# substitui SO o bloco gerenciado, preservando o resto que o humano escreveu
function Merge-Bloco([string]$corpo, [string]$bloco) {
    if ($corpo) { $corpo = $corpo.TrimStart([char]0xFEFF) }
    if ($corpo -and $corpo.Contains($ini) -and $corpo.Contains($fim)) {
        $pre = $corpo.Substring(0, $corpo.IndexOf($ini))
        $pos = $corpo.Substring($corpo.IndexOf($fim) + $fim.Length)
        return ($pre + $bloco + $pos)
    }
    if ($corpo) { return ($bloco + "`n`n" + $corpo) }
    return $bloco
}

# cria o arquivo (cabecalho + cabecalho da tabela) se ainda nao existe
function New-Cabecalho([string]$path, [bool]$comGit) {
    $tituloTxt = if ($Titulo) { $Titulo } else { $Task }
    $l = @("# Diário de bordo — Task ${Task}: $tituloTxt")
    if ($comGit) { $l += "Branch: $Branch · Início: $ts" } else { $l += "Início: $ts (modo local, sem git)" }
    $l += ''
    $l += '## Atualização em tempo real'
    $l += ''
    $l += '| Quando | Etapa | Atualização |'
    $l += '| --- | --- | --- |'
    Write-Txt $path (($l -join "`n") + "`n")
}

# --- decide modo: repo (com remote) x local ---
$modoRepo = $false
if ($Repo) {
    if (-not (Test-Path (Join-Path $Repo '.git'))) { Write-Host "ERRO: nao e repo git: $Repo"; exit 1 }
    $eapOld = $ErrorActionPreference; $ErrorActionPreference = 'SilentlyContinue'
    $remotes = (git -C $Repo remote 2>&1)
    $ErrorActionPreference = $eapOld
    if ($remotes) { $modoRepo = $true } else { Write-Host "AVISO: repo sem remote -> modo local (sem push)." }
}

# --- modo local (sem repo/sem remote) ---
if (-not $modoRepo) {
    $dirLocal = Join-Path (Join-Path $raiz 'squad') 'progresso'
    if (-not (Test-Path $dirLocal)) { New-Item -ItemType Directory -Path $dirLocal -Force | Out-Null }
    $arqPath = Join-Path $dirLocal "$Task.md"
    if (-not (Test-Path $arqPath)) { New-Cabecalho $arqPath $false }
    Add-Txt $arqPath $linhaTab
    Write-Host "Modo local: '$etapa' anexado em squad\progresso\$Task.md (sem push)."
    exit 0
}

# --- modo repo ---
if (-not $Branch) { Write-Host "ERRO: modo repo exige -Branch (ex.: squad/$Task)."; exit 1 }
if ($Branch -notmatch '^squad/') {
    Write-Host "BLOQUEADO: o diario so opera em branch squad/* (recebido: '$Branch')." -ForegroundColor Red
    Write-Host "Nunca commite o diario na branch principal - merge e do humano."
    exit 1
}
if (-not $Base) {
    $manPath = Join-Path (Join-Path $raiz 'squad') '.squadkit.json'
    if (Test-Path $manPath) { try { $Base = (Get-Content $manPath -Raw | ConvertFrom-Json).branch } catch {} }
}
if (-not $Base) { $Base = 'main' }

$arqNome = "PROGRESSO-$Task.md"
$arqPath = Join-Path $Repo $arqNome
if (-not (Test-Path $arqPath)) { New-Cabecalho $arqPath $true }
Add-Txt $arqPath $linhaTab
Write-Host "'$etapa' anexado em $arqNome"

if ($SemPush) { Write-Host "-SemPush: parei antes de commit/push (dry-run)."; exit 0 }

$eapOld = $ErrorActionPreference; $ErrorActionPreference = 'SilentlyContinue'
git -C $Repo add -- $arqNome 2>&1 | Out-Null
git -C $Repo commit -m "chore(squad): diario $Task - $etapa" 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "AVISO: nada a commitar." }
git -C $Repo push origin $Branch 2>&1 | Out-Null
$okPush = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $eapOld
if ($okPush) { Write-Host "Push OK -> origin/$Branch" } else { Write-Host "AVISO: push falhou (verifique credenciais/remote)."; exit 0 }

if ($SemPR) { Write-Host "-SemPR: nao mexo em PR/MR. Registro = arquivo na branch."; exit 0 }

# --- DESCRICAO do PR/MR (a vitrine) - best-effort, nunca trava a task ---
$ErrorActionPreference = 'SilentlyContinue'
$bloco = New-BlocoDescricao $arqPath
$tmp = [IO.Path]::GetTempFileName()
try {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $n = (gh pr list --head $Branch --json number --jq '.[0].number' 2>$null)
        if (-not $n) {
            Write-Txt $tmp $bloco
            $tituloPr = "squad: $Task" + $(if ($Titulo) { " - $Titulo" } else { '' })
            gh pr create --draft --base $Base --head $Branch --title $tituloPr --body-file $tmp 2>$null | Out-Null
            $n = (gh pr list --head $Branch --json number --jq '.[0].number' 2>$null)
            if ($n) { Write-Host "PR rascunho aberto (#$n) com a tabela do diario." }
        } else {
            $atual = (gh pr view $n --json body --jq '.body' 2>$null)
            Write-Txt $tmp (Merge-Bloco $atual $bloco)
            gh pr edit $n --body-file $tmp 2>$null | Out-Null
            Write-Host "Descricao do PR #$n atualizada ($etapa)."
        }
    }
    elseif (Get-Command glab -ErrorAction SilentlyContinue) {
        $lista = (glab mr list --source-branch $Branch 2>$null | Select-String -Pattern '!(\d+)')
        $n = if ($lista) { $lista[0].Matches[0].Groups[1].Value } else { $null }
        if (-not $n) {
            $tituloMr = "squad: $Task" + $(if ($Titulo) { " - $Titulo" } else { '' })
            glab mr create --draft --source-branch $Branch --target-branch $Base --title $tituloMr --description $bloco --yes 2>$null | Out-Null
            Write-Host "MR rascunho criado com a tabela do diario."
        } else {
            glab mr update $n --description $bloco 2>$null | Out-Null
            Write-Host "Descricao do MR !$n atualizada ($etapa)."
        }
    }
    else { Write-Host "AVISO: gh/glab ausentes - PR/MR pulado. O arquivo na branch e o registro." }
} catch { Write-Host "AVISO: PR/MR pulado (best-effort, nao trava a task)." }
finally { Remove-Item $tmp -ErrorAction SilentlyContinue }
exit 0
