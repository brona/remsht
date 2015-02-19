# 2015 Bronislav Robenek <brona@robenek.me>
function printlog(msg)
{
  printf("[%s] %s\n",strftime("%Y-%m-%d %H:%M:%S"),msg)
}
function abs(value)
{
  return (value<0?-value:value);
}
BEGIN {
  printlog("remsht_local.gawk started")
  secret = "Password123"
  max_time_diff = 60*5
  FS=";"
}
{
  if (length() > 1000) {
    printlog("Recieved >1000 chars, ignoring")
    next
  }
  if ($0 != "") {
    printlog("Recieved " $0)
    if (NF == 3) {
      ts =gensub(/[^0-9]/,"","g",$1)
      cmd=gensub(/[^a-zA-Z0-9: -_]/,"","g",$2)
      msg=ts ";" cmd

      chckcmd = "echo \"" msg "\" | openssl sha1 -hmac \"" secret "\""
      chckcmd | getline checksum
      close(chckcmd)

      curr_time = strftime("%s")

      if (checksum == $3 && abs(curr_time - ts) <= max_time_diff) {
        printlog("Digest is VALID")
        if (cmd == "shutdown") {
          printlog("Executing shutdown")
          shcmd="shutdown -h now \"UPS Monitor initiated shutdown\""
          #system(shcmd)
          print shcmd
        }
      }
      else
      {
        printlog("Digest is INVALID")
      }
    }
  }
  fflush()
}
END {
  printlog("remsht_local.gawk Terminated")
}
