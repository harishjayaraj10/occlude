using REPL.TerminalMenus

const DEMOS = [Mobius()]

function main()
  labels = [name(d) for d in DEMOS]
  menu = RadioMenu(labels)
  choice = request("Pick a demo:", menu)

  if choice == -1
    println("Bye!")
    return
  end

  launch(DEMOS[choice])
end
