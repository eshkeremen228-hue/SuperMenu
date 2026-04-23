#Requires AutoHotkey v2.0
#SingleInstance Force

; ========== НАСТРОЙКИ ==========
Persistent

; Глобальные переменные
global clipHistory := []
global customApps := Map()
global settingsFile := A_ScriptDir "\supermenu_settings.ini"
global startupShortcut := A_Startup "\SuperMenu.lnk"
global notesFile := A_ScriptDir "\supermenu_notes.txt"

; Переменные темы
global currentBgColor := "1a1a2e"
global currentAccentColor := "00d4aa"
global currentTextColor := "FFFFFF"

; Переменные языка
global currentLang := "RU"
global showLangSelector := true

; Загрузка данных
LoadSettings()

; Словарь переводов
global LangData := Map(
    "RU", Map(
        "welcome", "⚡ SUPERMENU v4.1 ⚡",
        "sub_welcome", "Панель управления Windows",
        "office", "📁 Office",
        "browsers", "🌐 Браузеры",
        "system", "⚙️ Система",
        "tools", "🛠️ Инструменты",
        "custom", "⭐ Мои файлы/Папки",
        "settings", "⚙️ Параметры",
        "taskmgr", "🗂️ Диспетчер задач",
        "regedit", "📟 Редактор реестра",
        "cmd", "💻 Командная строка (CMD)",
        "ps", "💙 PowerShell",
        "as_admin", "🛡️ От имени админа",
        "normal", "👤 Обычный запуск",
        "kill_win", "💀 Убить активное окно",
        "hidden", "👁️ Показать/Скрыть файлы",
        "themes", "🎨 Палитры и Темы",
        "notes", "📝 Быстрая заметка",
        "save_as", "💾 Сохранить в файл...",
        "timer", "⏱️ Таймер",
        "alarm", "⏰ Будильник",
        "clipboard", "📋 История буфера",
        "lang_settings", "🌐 Язык / Language",
        "startup", "Автозагрузка",
        "help", "📖 Справка",
        "reload", "🔄 Перезапуск",
        "exit", "❌ Выход",
        "add_app", "➕ Добавить программу/папку/сайт",
        "del_app", "🗑️ Удалить пункт",
        "save", "💾 Сохранить",
        "start", "▶️ Запустить",
        "hours", "Ч:", "mins", "М:", "secs", "С:",
        "timer_done", "Время вышло!",
        "alarm_done", "ПОРА ВСТАВАТЬ!",
        "hotkeys", "Alt+Z`t→ Главное меню`nWin+T`t→ Терминал`nWin+Shift+A`t→ Поверх всех`nWin+Shift+C`t→ Путь файла`nWin+Shift+J`t→ Заметки`nWin+Shift+K`t→ Убить окно`nWin+Shift+H`t→ Скрытые файлы`nWin+Shift+T`t→ Таймер`nWin+Shift+V`t→ Буфер`nWin+F1`t→ Справка`nWin+Shift+Q`t→ Выход"
    ),
    "EN", Map(
        "welcome", "⚡ SUPERMENU v4.1 ⚡",
        "sub_welcome", "Windows Control Panel",
        "office", "📁 Office",
        "browsers", "🌐 Browsers",
        "system", "⚙️ System",
        "tools", "🛠️ Tools",
        "custom", "⭐ My Files/Folders",
        "settings", "⚙️ Settings",
        "taskmgr", "🗂️ Task Manager",
        "regedit", "📟 Registry Editor",
        "cmd", "💻 Command Prompt (CMD)",
        "ps", "💙 PowerShell",
        "as_admin", "🛡️ Run as Admin",
        "normal", "👤 Normal Run",
        "kill_win", "💀 Kill Active Window",
        "hidden", "👁️ Show/Hide Files",
        "themes", "🎨 Themes & Palettes",
        "notes", "📝 Quick Note",
        "save_as", "💾 Save to File...",
        "timer", "⏱️ Timer",
        "alarm", "⏰ Alarm Clock",
        "clipboard", "📋 Clipboard History",
        "lang_settings", "🌐 Language / Язык",
        "startup", "Startup",
        "help", "📖 Help",
        "reload", "🔄 Reload",
        "exit", "❌ Exit",
        "add_app", "➕ Add App/Folder/Website",
        "del_app", "🗑️ Remove Item",
        "save", "💾 Save",
        "start", "▶️ Start",
        "hours", "H:", "mins", "M:", "secs", "S:",
        "timer_done", "Time is up!",
        "alarm_done", "WAKE UP!",
        "hotkeys", "Alt+Z`t→ Main Menu`nWin+T`t→ Terminal`nWin+Shift+A`t→ Always on Top`nWin+Shift+C`t→ Copy Path`nWin+Shift+J`t→ Quick Notes`nWin+Shift+K`t→ Kill Window`nWin+Shift+H`t→ Hidden Files`nWin+Shift+T`t→ Timer`nWin+Shift+V`t→ Clipboard`nWin+F1`t→ Help`nWin+Shift+Q`t→ Exit"
    )
)

T(key) => LangData[currentLang][key]

; ========== ФУНКЦИИ СОХРАНЕНИЯ ==========

LoadSettings() {
    global customApps, currentBgColor, currentAccentColor, currentTextColor, currentLang, showLangSelector
    if FileExist(settingsFile) {
        try {
            try {
                content := IniRead(settingsFile, "Apps")
            } catch {
                content := ""
            }
            loop parse, content, "`n", "`r" {
                if InStr(A_LoopField, "=") {
                    parts := StrSplit(A_LoopField, "=", , 2)
                    customApps[parts[1]] := parts[2]
                }
            }
            currentBgColor := IniRead(settingsFile, "Theme", "Bg", "1a1a2e")
            currentAccentColor := IniRead(settingsFile, "Theme", "Accent", "00d4aa")
            currentTextColor := IniRead(settingsFile, "Theme", "Text", "FFFFFF")
            currentLang := IniRead(settingsFile, "Settings", "Language", "RU")
            showLangSelector := (IniRead(settingsFile, "Settings", "ShowLangSelector", "1") = "1")
        }
    }
}

SaveSettings() {
    if FileExist(settingsFile) {
        FileDelete(settingsFile)
    }
    for name, path in customApps {
        IniWrite(path, settingsFile, "Apps", name)
    }
    IniWrite(currentBgColor, settingsFile, "Theme", "Bg")
    IniWrite(currentAccentColor, settingsFile, "Theme", "Accent")
    IniWrite(currentTextColor, settingsFile, "Theme", "Text")
    IniWrite(currentLang, settingsFile, "Settings", "Language")
    IniWrite(showLangSelector ? "1" : "0", settingsFile, "Settings", "ShowLangSelector")
}

; ========== УПРАВЛЕНИЕ ЯЗЫКОМ ==========

ChangeLanguage(langCode) {
    global currentLang
    currentLang := langCode
    SaveSettings()
    Reload()
}

ToggleLangSelector(*) {
    global showLangSelector
    showLangSelector := !showLangSelector
    SaveSettings()
    Reload()
}

ShowInitialLangSelector() {
    global currentLang, showLangSelector
    if (!showLangSelector) {
        return
    }
    langGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    langGui.BackColor := currentBgColor
    langGui.SetFont("s14 c" currentAccentColor " Bold", "Consolas")
    langGui.AddText("w300 Center y20", "SELECT LANGUAGE")
    langGui.SetFont("s11 c" currentTextColor)
    btnRU := langGui.AddButton("w120 h40 x20 y+20", "Русский")
    btnEN := langGui.AddButton("w120 h40 x160 yP", "English")
    chkSkip := langGui.AddCheckbox("x20 y+20 c" currentTextColor, "Don't show this again / Больше не показывать")
    
    btnRU.OnEvent("Click", (*) => FinishSelection(chkSkip.Value, "RU"))
    btnEN.OnEvent("Click", (*) => FinishSelection(chkSkip.Value, "EN"))
    
    FinishSelection(skip, lang) {
        global currentLang, showLangSelector
        currentLang := lang
        showLangSelector := !skip
        SaveSettings()
        langGui.Destroy()
    }
    
    langGui.Show("Center")
}

; ========== СИСТЕМНЫЕ ФУНКЦИИ ==========

KillActiveWindow(*) {
    try {
        activeHwnd := WinGetID("A")
        activePID := WinGetPID("ahk_id " activeHwnd)
        ProcessClose(activePID)
        TrayTip("System", currentLang="RU" ? "Процесс завершен" : "Process terminated", 10)
    }
}

ToggleHiddenFiles(*) {
    rootKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    current := RegRead(rootKey, "Hidden")
    newVal := (current = 2) ? 1 : 2
    RegWrite(newVal, "REG_DWORD", rootKey, "Hidden")
    SendMessage(0x111, 28931, , , "ahk_class Progman")
    TrayTip("Explorer", (newVal = 1 ? (currentLang="RU" ? "Файлы показаны" : "Files shown") : (currentLang="RU" ? "Файлы скрыты" : "Files hidden")), 10)
}

ShowScratchpad(*) {
    noteGui := Gui("+AlwaysOnTop", T("notes"))
    noteGui.BackColor := currentBgColor
    noteGui.SetFont("s10 c" currentAccentColor " Bold", "Consolas")
    noteGui.AddText("w400 Center", "📝 " T("notes"))
    noteGui.SetFont("s11 c" currentTextColor, "Consolas")
    existingText := FileExist(notesFile) ? FileRead(notesFile) : ""
    editBox := noteGui.AddEdit("w400 h300 Multi Background333344 c" currentTextColor, existingText)
    
    noteGui.AddButton("w140 h35 x50 y+15", T("save")).OnEvent("Click", (*) => (
        FileDelete(notesFile), FileAppend(editBox.Value, notesFile), noteGui.Destroy()
    ))
    
    noteGui.AddButton("w140 h35 x210 yP", T("save_as")).OnEvent("Click", (*) => SaveNoteToCustomFolder(editBox.Value))
    
    noteGui.Show()
}

SaveNoteToCustomFolder(text) {
    folders := []
    for name, path in customApps {
        if DirExist(path) {
            folders.Push({name: name, path: path})
        }
    }
    
    if (folders.Length = 0) {
        dest := FileSelect("S16", , "Save Note", "Text Documents (*.txt)")
        if (dest) {
            FileAppend(text, dest)
        }
        return
    }
    
    saveGui := Gui("+AlwaysOnTop", T("save_as"))
    saveGui.BackColor := currentBgColor
    saveGui.SetFont("s10 c" currentTextColor)
    saveGui.AddText("w300", currentLang="RU" ? "Выберите папку для сохранения:" : "Choose folder to save:")
    
    folderNames := []
    for f in folders {
        folderNames.Push(f.name)
    }
    
    lb := saveGui.AddListBox("w300 h150 Background333344 c" currentTextColor, folderNames)
    saveGui.AddText("w300", currentLang="RU" ? "Имя файла:" : "File name:")
    fnEdit := saveGui.AddEdit("w300 Background333344 c" currentTextColor, "note_" FormatTime(, "yyyyMMdd_HHmm") ".txt")
    
    saveGui.AddButton("w100 h30 x100 y+15", "OK").OnEvent("Click", (*) => (
        idx := lb.Value,
        idx ? (
            fullPath := folders[idx].path "\" fnEdit.Value,
            FileAppend(text, fullPath),
            MsgBox(currentLang="RU" ? "Файл сохранен: " fullPath : "File saved: " fullPath),
            saveGui.Destroy()
        ) : MsgBox("Choose a folder!")
    ))
    saveGui.Show()
}

ApplyColorTheme(themeName) {
    global currentBgColor, currentAccentColor, currentTextColor
    themes := Map(
        "Blue", ["1a1a2e", "00d4aa", "FFFFFF"], "Green", ["0b2410", "4cff88", "FFFFFF"], 
        "Red", ["2e1a1a", "ff4c4c", "FFFFFF"], "Dark", ["121212", "bb86fc", "FFFFFF"], "Light", ["F0F0F0", "0078D7", "000000"]
    )
    if themes.Has(themeName) {
        currentBgColor := themes[themeName][1], currentAccentColor := themes[themeName][2], currentTextColor := themes[themeName][3]
        try {
            regKey := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            RegWrite((themeName = "Light" ? 1 : 0), "REG_DWORD", regKey, "AppsUseLightTheme")
            RegWrite((themeName = "Light" ? 1 : 0), "REG_DWORD", regKey, "SystemUsesLightTheme")
        }
        SaveSettings()
        Reload()
    }
}

; ========== УВЕДОМЛЕНИЯ ==========

ShowTimerNotify(msg) {
    notify := Gui("+AlwaysOnTop -Caption +ToolWindow")
    notify.BackColor := currentAccentColor
    notify.SetFont("s20 cFFFFFF Bold", "Consolas")
    notify.AddText("w500 Center y20", T("timer_done"))
    notify.Show("Center NoActivate")
    Sleep(3000)
    notify.Destroy()
}

ShowAlarmNotify(msg) {
    notify := Gui("+AlwaysOnTop -Caption +ToolWindow")
    notify.BackColor := "ff4c4c"
    notify.SetFont("s22 cFFFFFF Bold", "Consolas")
    notify.AddText("w600 Center y30", T("alarm_done"))
    notify.Show("Center NoActivate")
    loop 6 {
        notify.BackColor := "ff4c4c"
        Sleep(300)
        notify.BackColor := "ffcc00"
        Sleep(300)
    }
    notify.Destroy()
}

; ========== СПРАВКА ==========
ShowWelcome(*) {
    welcome := Gui("+AlwaysOnTop -Caption +ToolWindow")
    welcome.BackColor := currentBgColor
    welcome.SetFont("s18 c" currentAccentColor " Bold", "Consolas")
    welcome.AddText("w450 Center", T("welcome"))
    welcome.SetFont("s11 c" currentTextColor)
    welcome.AddText("w450 Center", T("sub_welcome"))
    welcome.AddText("w450 h2 Background" currentAccentColor, "")
    welcome.SetFont("s10")
    welcome.AddText("w450", T("hotkeys"))
    welcome.AddButton("w100 h35 x175 y+15", "OK").OnEvent("Click", (*) => welcome.Destroy())
    welcome.Show("Center")
}

; ========== ГЛАВНОЕ МЕНЮ ==========
!z:: {
    MyMenu := Menu()
    
    officeMenu := Menu()
    officeMenu.Add("📄 Word", (*) => SafeRun("winword.exe"))
    officeMenu.Add("📊 PowerPoint", (*) => SafeRun("powerpnt.exe"))
    officeMenu.Add("📈 Excel", (*) => SafeRun("excel.exe"))
    
    browserMenu := Menu()
    browserMenu.Add("🌐 Chrome", (*) => SafeRun("chrome.exe"))
    browserMenu.Add("🦊 Firefox", (*) => SafeRun("firefox.exe"))
    browserMenu.Add("🌊 Edge", (*) => SafeRun("msedge.exe"))

    cmdSub := Menu()
    cmdSub.Add(T("normal"), (*) => Run("cmd.exe"))
    cmdSub.Add(T("as_admin"), (*) => Run("*RunAs cmd.exe"))
    
    psSub := Menu()
    psSub.Add(T("normal"), (*) => Run("powershell.exe"))
    psSub.Add(T("as_admin"), (*) => Run("*RunAs powershell.exe"))

    systemMenu := Menu()
    systemMenu.Add(T("settings"), (*) => Run("ms-settings:"))
    systemMenu.Add(T("taskmgr"), (*) => Run("taskmgr.exe"))
    systemMenu.Add(T("regedit"), (*) => Run("*RunAs regedit.exe"))
    systemMenu.Add(T("cmd"), cmdSub)
    systemMenu.Add(T("ps"), psSub)
    systemMenu.Add()
    systemMenu.Add(T("kill_win"), KillActiveWindow)
    systemMenu.Add(T("hidden"), ToggleHiddenFiles)
    
    langMenu := Menu()
    langMenu.Add("Русский", (*) => ChangeLanguage("RU"))
    langMenu.Add("English", (*) => ChangeLanguage("EN"))
    langMenu.Add()
    langMenu.Add((showLangSelector ? "✅ " : "⬜ ") (currentLang="RU" ? "Выбор при запуске" : "Selector on startup"), ToggleLangSelector)

    themeMenu := Menu()
    themeMenu.Add("🌑 Dark Mode", (*) => ApplyColorTheme("Dark"))
    themeMenu.Add("☀️ Light Mode", (*) => ApplyColorTheme("Light"))
    themeMenu.Add()
    themeMenu.Add("🔵 Deep Blue", (*) => ApplyColorTheme("Blue"))
    themeMenu.Add("🟢 Forest Green", (*) => ApplyColorTheme("Green"))
    themeMenu.Add("🔴 Crimson Red", (*) => ApplyColorTheme("Red"))
    
    toolsMenu := Menu()
    toolsMenu.Add(T("notes"), ShowScratchpad)
    toolsMenu.Add(T("timer"), (*) => ShowTimer())
    toolsMenu.Add(T("alarm"), (*) => ShowAlarm())
    toolsMenu.Add(T("clipboard"), (*) => ShowClipboardHistory())
    toolsMenu.Add(T("themes"), themeMenu)
    toolsMenu.Add(T("lang_settings"), langMenu)
    
    customMenu := Menu()
    customMenu.Add(T("add_app"), (*) => AddCustomApp())
    customMenu.Add(T("del_app"), (*) => DeleteCustomApp())
    if (customApps.Count > 0) {
        customMenu.Add()
        for name, path in customApps {
            callback := RunWrapper.Bind(path)
            customMenu.Add(name, callback)
        }
    }
    
    MyMenu.Add(T("office"), officeMenu)
    MyMenu.Add(T("browsers"), browserMenu)
    MyMenu.Add(T("system"), systemMenu)
    MyMenu.Add(T("tools"), toolsMenu)
    MyMenu.Add(T("custom"), customMenu)
    MyMenu.Add()
    MyMenu.Add((FileExist(startupShortcut) ? "✅ " : "⬜ ") T("startup"), (*) => ToggleStartup())
    MyMenu.Add(T("help"), ShowWelcome)
    MyMenu.Add(T("reload"), (*) => Reload())
    MyMenu.Add(T("exit"), (*) => ExitApp())
    MyMenu.Show()
}

RunWrapper(path, *) => SafeRun(path)

SafeRun(target) {
    try {
        if (RegExMatch(target, "i)^https?://|www\.")) {
            Run(target)
        } else {
            Run(target)
        }
    } catch {
        try {
            Run('"' target '"')
        } catch as e {
            MsgBox("Error: " e.Message)
        }
    }
}

ToggleStartup(*) {
    if FileExist(startupShortcut) {
        FileDelete(startupShortcut)
    } else {
        FileCreateShortcut(A_ScriptFullPath, startupShortcut)
    }
    Reload()
}

; ========== ГОРЯЧИЕ КЛАВИШИ ==========
#t:: {
    try {
        Run("powershell.exe")
    } catch {
        Run("cmd.exe")
    }
}
#+a:: WinSetAlwaysOnTop(-1, "A")
#+c:: {
    path := ControlGetText("Edit1", "A")
    if (path) {
        A_Clipboard := path
        TrayTip("Copied", path)
    }
}
#+k:: KillActiveWindow()
#+h:: ToggleHiddenFiles()
#+j:: ShowScratchpad()
#+n:: Send("!z")
#+t:: ShowTimer()
#+v:: ShowClipboardHistory()
#F1:: ShowWelcome()
#+q:: ExitApp()

; ========== ИСТОРИЯ БУФЕРА ==========
OnClipboardChange(SaveClipboard)

SaveClipboard(type) {
    if (type != 1 || A_Clipboard == "") {
        return
    }
    for i, v in clipHistory {
        if (v == A_Clipboard) {
            clipHistory.RemoveAt(i)
            break
        }
    }
    clipHistory.InsertAt(1, A_Clipboard)
    if (clipHistory.Length > 20) {
        clipHistory.Pop()
    }
}

ShowClipboardHistory() {
    hGui := Gui("+AlwaysOnTop", T("clipboard"))
    hGui.BackColor := currentBgColor
    items := []
    for i in clipHistory {
        items.Push(StrLen(i) > 45 ? SubStr(StrReplace(i, "`r`n", " "), 1, 45) "..." : StrReplace(i, "`r`n", " "))
    }
    list := hGui.AddListBox("w350 h250 Background333344 c" currentTextColor, items)
    list.OnEvent("DoubleClick", (*) => ( (idx:=list.Value) ? (A_Clipboard:=clipHistory[idx], hGui.Destroy()) : 0 ))
    hGui.Show()
}

; ========== ТАЙМЕР И БУДИЛЬНИК ==========
ShowTimer() {
    tGui := Gui("+AlwaysOnTop", T("timer"))
    tGui.BackColor := currentBgColor
    tGui.SetFont("s10 c" currentTextColor)
    tGui.AddText("x20 y50", T("hours"))
    hE := tGui.AddEdit("x40 y47 w40 Background333344 c" currentTextColor " Center", "0")
    tGui.AddText("x90 y50", T("mins"))
    mE := tGui.AddEdit("x110 y47 w40 Background333344 c" currentTextColor " Center", "5")
    tGui.AddText("x160 y50", T("secs"))
    sE := tGui.AddEdit("x180 y47 w40 Background333344 c" currentTextColor " Center", "0")
    tGui.AddButton("w200 h35 x50 y+20", T("start")).OnEvent("Click", (*) => (
        ms := (Integer(hE.Value)*3600 + Integer(mE.Value)*60 + Integer(sE.Value)) * 1000,
        (ms > 0) ? (SetTimer(() => ShowTimerNotify("Done"), -ms), tGui.Destroy()) : 0
    ))
    tGui.Show()
}

ShowAlarm() {
    aGui := Gui("+AlwaysOnTop", T("alarm"))
    aGui.BackColor := currentBgColor
    timeE := aGui.AddEdit("w200 x50 Background333344 c" currentTextColor " Center s14", FormatTime(, "HH:mm:ss"))
    aGui.AddButton("w200 h35 x50 y+15", T("save")).OnEvent("Click", (*) => (
        target := timeE.Value, 
        SetTimer(() => (FormatTime(, "HH:mm:ss") = target ? ShowAlarmNotify("Alarm") : ""), 1000), 
        aGui.Destroy()
    ))
    aGui.Show()
}

; ========== ПРОГРАММЫ ==========
AddCustomApp() {
    addGui := Gui("+AlwaysOnTop", T("add_app"))
    addGui.BackColor := currentBgColor
    addGui.SetFont("s10 c" currentTextColor)
    addGui.AddText("w350", (currentLang="RU" ? "Название (для меню):" : "Name (for menu):"))
    nE := addGui.AddEdit("w350 Background333344 c" currentTextColor)
    addGui.AddText("w350", (currentLang="RU" ? "Путь к файлу/папке или URL:" : "Path to file/folder or URL:"))
    pE := addGui.AddEdit("w350 Background333344 c" currentTextColor)
    btnF := addGui.AddButton("w150 h30 x20 y+15", (currentLang="RU" ? "Выбрать файл..." : "Select file..."))
    btnF.OnEvent("Click", (*) => ( (s := FileSelect()) ? (pE.Value := s, SplitPath(s, &n), nE.Value := n) : 0 ))
    btnD := addGui.AddButton("w150 h30 x180 yP", (currentLang="RU" ? "Выбрать папку..." : "Select folder..."))
    btnD.OnEvent("Click", (*) => ( (d := DirSelect()) ? (pE.Value := d, nE.Value := StrSplit(d, "\").Pop()) : 0 ))
    addGui.AddButton("w160 h35 x110 y+20", T("save")).OnEvent("Click", (*) => (
        (nE.Value && pE.Value) ? (customApps[nE.Value] := pE.Value, SaveSettings(), addGui.Destroy()) : 0
    ))
    addGui.Show()
}

DeleteCustomApp() {
    if (customApps.Count = 0) {
        return
    }
    delGui := Gui("+AlwaysOnTop", T("del_app"))
    delGui.BackColor := currentBgColor
    names := []
    for n, p in customApps {
        names.Push(n)
    }
    list := delGui.AddListBox("w300 h200 Background333344 c" currentTextColor, names)
    delGui.AddButton("w300 h35", (currentLang="RU" ? "Удалить" : "Delete")).OnEvent("Click", (*) => (
        (idx := list.Value) ? (customApps.Delete(names[idx]), SaveSettings(), delGui.Destroy()) : 0
    ))
    delGui.Show()
}

ShowInitialLangSelector()