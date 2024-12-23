#!/bin/bash                                                                                                                             
##############################################################################
# update-archive.sh, v0.1.0 - Updates existing kink.com archive.
#
# Copyright (C) 2021 MeanMrMustardGas <meanmrmustardgas at protonmail dot com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
##############################################################################

##############################################################################
# Configuration
##############################################################################
cmd="${HOME}/src/kinkdownloader/kinkdownloader.py --bio-dir ${HOME}/srv/emby/config/metadata/People/"
kink_base="${HOME}/xxx/kink.com"
##############################################################################

##############################################################################
# Beyond here; there be dragons!
##############################################################################
cd "$kink_base" || exit
find . -type d | tail -n +2 | sort | while read -r n; do

        chan=$(basename "$n")
        url="https://www.kink.com/channel/${chan}/latest/page/1"
        max=$(curl -s https://www.kink.com/channel/${chan}/latest/page/1 | \
                grep latest | awk '{print $4}' | sort -rn | head -n 1 | tr -d '[:space:]')
        re='^[0-9]+$'

        cd "${kink_base}/${chan}" || exit
        pwd
        if ! [[ $max =~ $re ]]; then
                if [[ $max == *"Scenes"* ]]; then
                        curl -s "$url" | grep -q 'class="top"' && max="1" || max="0"
                else
                        url="https://www.kink.com${max}"
                        max=$(curl -s "$url" | grep latest | awk '{print $4}' | sort -rn | head -n 1 | tr -d '[:space:]')
                        if ! [[ $max =~ $re ]]; then
                                curl -s "$url" | grep -q 'class="top"' && max="1" || max="0"
                        fi
                fi
        fi
        if [ "$max" -gt 0 ]; then
                for i in $(seq 1 "$max"); do
                        $cmd "$(echo "$url" | awk -F '/' 'NF{NF--};1' | sed s%\ %/%g)/${i}"
                done
        fi
done
