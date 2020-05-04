#!/bin/bash

function usage() {
  cat <<_EOT_
Usage:
  $0 [-v] [-h]

Description:
  このコマンドは日本の祝日を判定するスクリプトです。
  2020年以降の祝日で対応してます。
  オプション指定ない場合は今日の日付で判定します。

  数字指定する際は8桁の数字を指定してください。
  例）
  $ happy_holiday 20200429
  ->2020年04月29日は祝日です。
　　
_EOT_
}

# 春分の日判定
function spring_equinox(){
  if [ "${month}" -ne 03 ]; then
    echo 0
    return
  fi

  local equinox=`echo "scale=5; (${year} - 2000) * 0.242914 " | bc`
  local leap_year=$(((${year}-2000)/4))
  local result=`echo "scale=5; 20.69115+${equinox}-${leap_year} " | bc | sed s/\.[0-9,]*$//g`
  local re_weekday=`date -jf '%Y%m%d' "${year}${month}${result}" '+%w'`
  if [ "${re_weekday}" -eq 0 ]; then
    result=$(($result + 1))
  fi
  echo ${result}
  return
}

# 秋分の日判定
function autumn_equinox(){
  if [ "${month}" -ne 09 ]; then
    echo 0
    return
  fi

  local equinox=`echo "scale=5; (${year} - 2000) * 0.242914 " | bc`
  local leap_year=$(((${year}-2000)/4))
  local result=`echo "scale=5; 23.13260+${equinox}-${leap_year} " | bc | sed s/\.[0-9,]*$//g`
  local re_weekday=`date -jf '%Y%m%d' "${year}${month}${result}" '+%w'`
  if [ "${re_weekday}" -eq 0 ]; then
    result=$(($result + 1))

  fi
  echo ${result}
  return
}


readonly READ_ME=`usage`

if [ "${1}" = "-v" ]; then
  echo "${0} version 1.0.0"
  exit 1
fi

if [ "${1}" = "-h" ]; then
  echo "${READ_ME}"
  exit 1
fi

if [ "${#}" -eq 0 ]; then
  tar_date=`date +'%Y_%m_%d_%w'`
  tar_date_name="今日"
else

  if [[ "${1}" =~ ^202[0-9](0[1-9]|1[0-2])([0-2][0-9]|3[0-1])$ ]]; then
    tar_date=`date -jf '%Y%m%d' "${1}" '+%Y_%m_%d_%w'`
    tar_date_name=`date -jf '%Y%m%d' "${1}" '+%Y年%m月%d日'`

  else
    if [[ "${1}" =~ ^(19|201) ]]; then
      echo "2020年より以前の祝日には対応していません！"
      exit 1

    else
      echo "日付形式ではありません！"
      exit 1

    fi
  fi
fi


list=(${tar_date//_/ })
year=${list[0]}
month=${list[1]}
day=${list[2]}
weekday=${list[3]}
spring=`spring_equinox`
autumn=`autumn_equinox`
furikae="(振替休日)"

# 休日
if [ "${weekday}" -eq 0 -o "${weekday}" -eq 7 -o "${weekday}" -eq 6 ]; then
  echo "${tar_date_name}は休日です。"
  exit 1

# 年始休み
elif [ "${month}" -eq 01 -a "${day}" -lt 04 ]; then
  echo "${tar_date_name}は年始休みです。"
  exit 1

# 成人の日
elif [ "${month}" -eq 01 -a "${weekday}" -eq 1 -a "${day}" -gt 7 -a "${day}" -lt 15 ]; then
  echo "${tar_date_name}は成人の日です。"
  exit 1

# 建国記念日
elif [ "${month}" -eq 02 -a "${day}" -eq 11 -o "${month}" -eq 02 -a "${day}" -eq 12 -a "${weekday}" -eq 1 ]; then
  holiday_name="建国記念日"
  if [ "${day}" -eq 12 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 天皇誕生日
elif [ "${month}" -eq 02 -a "${day}" -eq 23 -o "${month}" -eq 02 -a "${day}" -eq 24 -a "${weekday}" -eq 1 ]; then
  holiday_name="天皇誕生日"
  if [ "${day}" -eq 24 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 秋分の日
elif [ "${month}" -eq 03 -a "${day}" -eq "${spring}" ]; then
  echo "${tar_date_name}は秋分の日です。"
  exit 1

# 昭和の日
elif [ "${month}" -eq 04 -a "${day}" -eq 29 -o "${month}" -eq 04 -a "${day}" -eq 30 -a "${weekday}" -eq 1 ]; then
  holiday_name="昭和の日"
  if [ "${day}" -eq 30 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 憲法記念日
elif [ "${month}" -eq 05 -a "${day}" -eq 03 -o "${month}" -eq 05 -a "${day}" -eq 06 -a "${weekday}" -eq 3 ]; then
  holiday_name="憲法記念日"
  if [ "${day}" -eq 06 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# みどりの日
elif [ "${month}" -eq 05 -a "${day}" -eq 04 -o "${month}" -eq 05 -a "${day}" -eq 06 -a "${weekday}" -eq 2 ]; then
  holiday_name="みどりの日"
  if [ "${day}" -eq 06 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# こどもの日
elif [ "${month}" -eq 05 -a "${day}" -eq 05 -o "${month}" -eq 05 -a "${day}" -eq 06 -a "${weekday}" -eq 1 ]; then
  holiday_name="こどもの日"
  if [ "${day}" -eq 06 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 海の日
elif [ "${year}" -ne 2020 -a "${month}" -eq 07 -a "${weekday}" -eq 1 -a "${day}" -gt 14 -a "${day}" -lt 22 \
    -o "${year}" -eq 2020 -a "${month}" -eq 07 -a "${day}" -eq 23 ]; then
  echo "${tar_date_name}は海の日です。"
  exit 1

# 山の日
elif [ "${year}" -ne 2020 -a "${month}" -eq 08 -a "${day}" -eq 11 \
    -o "${year}" -ne 2020 -a "${month}" -eq 08 -a "${day}" -eq 12 -a "${weekday}" -eq 1 \
    -o "${year}" -eq 2020 -a "${month}" -eq 08 -a "${day}" -eq 10 ]; then
  holiday_name="山の日"
  if [ "${year}" -ne 2020 -a "${day}" -eq 12 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 敬老の日
elif [ "${month}" -eq 09 -a "${weekday}" -eq 1 -a "${day}" -gt 14 -a "${day}" -lt 22 ]; then
  echo "${tar_date_name}は敬老の日です。"
  exit 1

# 国民の休日
elif [ "${month}" -eq 09 -a "${day}" -eq 22 -a "${weekday}" -eq 2 -a "${autumn}" -eq 23 ]; then
  echo "${tar_date_name}は国民の祝日です。"

# 秋分の日
elif [ "${month}" -eq 09 -a "${day}" -eq "${autumn}" ]; then
  echo "${tar_date_name}は秋分の日です。"
  exit 1

# スポーツの日
elif [ "${year}" -ne 2020 -a "${month}" -eq 10 -a "${weekday}" -eq 1 -a "${day}" -gt 7 -a "${day}" -lt 15 \
    -o "${year}" -eq 2020 -a "${month}" -eq 07 -a "${day}" -eq 24 ]; then
  echo "${tar_date_name}はスポーツの日です。"
  exit 1

# 文化の日
elif [ "${month}" -eq 11 -a "${day}" -eq 03 -o "${month}" -eq 11 -a "${day}" -eq 04 -a "${weekday}" -eq 1 ]; then
  holiday_name="文化の日"
  if [  "${day}" -eq 04 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 勤労感謝の日
elif [ "${month}" -eq 11 -a "${day}" -eq 23 -o "${month}" -eq 11 -a "${day}" -eq 24 -a "${weekday}" -eq 1 ]; then
  holiday_name="勤労感謝の日"
  if [ "${day}" -eq 24 ]; then
      holiday_name="${holiday_name}${furikae}"
  fi
  echo "${tar_date_name}は${holiday_name}です。"
  exit 1

# 年末休み
elif [ "${month}" -eq 12 -a "${day}" -gt 28 ]; then
  echo "${tar_date_name}は年末休みです。"
  exit 1

# 平日
else
  echo "${tar_date_name}は平日です。"
  exit 0

fi

exit 0