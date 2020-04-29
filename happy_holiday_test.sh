#!/bin/bash

if [ "${1}" -lt 2020 ]; then
  echo "2020年以降の年を指定してください。"
  exit 1
fi

for i in {01..12}; do
  for d in {01..31}; do
    if [ "${i}" -eq 4 -a "${d}" -eq 31 \
      -o "${i}" -eq 6 -a "${d}" -eq 31 \
      -o "${i}" -eq 9 -a "${d}" -eq 31 \
      -o "${i}" -eq 11 -a "${d}" -eq 31 ]; then
      break
    fi

    if [ $(("${1}" % 4)) -ne 0 -a "${i}" -eq 2 -a "${d}" -ge 29 \
      -o $(("${1}" % 4)) -eq 0 -a "${i}" -eq 2 -a "${d}" -ge 30 ]; then
      break
    fi

   ./happy_holiday.sh "${1}${i}${d}"
  done
done

exit 0