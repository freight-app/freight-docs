Output static/img/terminal/packaging.gif

Set FontSize 16
Set Width 960
Set Height 540
Set Theme "Dracula"
Set Shell "bash"

Type "freight build --release"
Enter
Sleep 600ms
Type "freight install --prefix /usr/local --destdir target/stage --no-build"
Enter
Sleep 700ms
Type "freight package --target x86_64-linux-gnu,aarch64-linux-gnu"
Enter
Sleep 700ms
Type "freight package --installer"
Enter
Sleep 700ms
