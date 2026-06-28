for i in {30..37}; do
  echo -e "\033[${i}mForeground color $i\033[0m"
done

for i in {90..97}; do
  echo -e "\033[${i}mForeground color $i\033[0m"
done

for i in {40..47}; do
  echo -e "\033[${i}mBackground color $i\033[0m"
done

for i in {0..255}; do
  printf "\033[38;5;%sm%3d\033[0m " "$i" "$i"
  if (( (i + 1) % 16 == 0 )); then
    echo
  fi
done
