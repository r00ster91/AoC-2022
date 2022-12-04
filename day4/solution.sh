#!/usr/bin/bash

# we need to pipe our data to the `while`s using process substitution
# so that our variables stay in scope.
# it looks like this: `done < <(...)`

# note that the script takes about 15 seconds to finish executing

containing_pair_count=0
pair_overlap_count=0
while read line
do
    ##########
    # PART 1 #
    ##########
    index=0
    pair2=""
    # this is a longer version of using `head -n1` and `tail -n1` like below
    while read pair; do
        if [ $index = 0 ]; then
            pair1="$pair"
        elif [ $index = 1 ]; then
            pair2="$pair"
        fi
        index=$((index + 1))
    done < <(echo $line | tr ',' '\n')
    start1=$(echo $pair1 | tr '-' '\n' | head -n1)
    end1=$(echo $pair1 | tr '-' '\n' | tail -n1)
    start2=$(echo $pair2 | tr '-' '\n' | head -n1)
    end2=$(echo $pair2 | tr '-' '\n' | tail -n1)
    if ([ $start1 -le $start2 ] && [ $end1 -ge $end2 ]) ||
       ([ $start1 -ge $start2 ] && [ $end1 -le $end2 ])
    then
       containing_pair_count=$((containing_pair_count + 1))
    fi

    ##########
    # PART 2 #
    ##########
    pair1_range=$(echo $pair1 | sed s/-/../)
    pair2_range=$(echo $pair2 | sed s/-/../)
    # brace expansion of ranges do not accept variables
    eval "
    for x in {$pair1_range}
    do
        for y in {$pair2_range}
        do
            if [ \$x = \$y ]
            then
                pair_overlap_count=$((pair_overlap_count + 1))
            fi
        done
    done
    "
done < <(cat input)

echo "Part 1: $containing_pair_count"
echo "Part 2: $pair_overlap_count"
