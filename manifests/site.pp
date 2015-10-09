Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

Apt::Source {
  architecture => $::architecture
}

Apt::Source <| |> ->Package <|
  provider != 'dpkg' and title != 'software-properties-common'
|>

include base
