#include <stdlib.h>
#include <assert.h>
#include <stdio.h>

struct Slice {
    char* ptr;
    size_t len;
};

struct Rucksack {
    struct Slice compartment1;
    struct Slice compartment2;
    char shared_item_type;
};

struct Slice Rucksack_get_all_item_types(struct Rucksack rucksack) {
    return (struct Slice){
        .ptr = rucksack.compartment1.ptr,
        .len = rucksack.compartment1.len + rucksack.compartment2.len
    };
}

char get_item_type_priority(char item_type) {
    char priority;
    if (item_type >= 'A' && item_type <= 'Z')
        priority = item_type - 'A' + 27;
    if (item_type >= 'a' && item_type <= 'z')
        priority = item_type - 'a' + 1;
    return priority;
}

struct Slice get_input() {
    FILE* file = fopen("input", "r");
    fseek(file, 0, SEEK_END);
    unsigned long file_len = ftell(file);
    fseek(file, 0, SEEK_SET);
    char* input = malloc(file_len);
    assert(fread(input, 1, file_len, file) == file_len);
    fclose(file);
    return (struct Slice){
        .ptr = input,
        .len = file_len,
    };
}

int main() {
    struct Slice input = get_input();

    printf("len=%ld\n", input.len);

    struct Rucksack* rucksacks = 0;
    size_t rucksacks_len = 0;

    struct Rucksack rucksack;

    for (size_t index = 0; index < input.len; index++) {
        size_t start = index;
        while (input.ptr[index] != '\n')
            index++;
        size_t end = index - start;
        assert(end % 2 == 0);
        rucksack.compartment1 = (struct Slice){
            .ptr = input.ptr + start,
            .len = end / 2,
        };
        rucksack.compartment2 = (struct Slice){
            .ptr = input.ptr + start + end / 2,
            .len = end / 2,
        };

        char shared_item_type;
        for (size_t index1 = 0; index1 < rucksack.compartment1.len; index1++) {
            char item_type_to_find = *(rucksack.compartment1.ptr + index1);
            for (size_t index2 = 0; index2 < rucksack.compartment2.len; index2++) {
                if (item_type_to_find == *(rucksack.compartment2.ptr + index2)) {
                    shared_item_type = item_type_to_find;
                    goto part_1_shared_item_type_found;
                }
            }
        }
        assert(0);
        part_1_shared_item_type_found:
        rucksack.shared_item_type = shared_item_type;

        rucksacks = realloc(rucksacks, sizeof(struct Rucksack) * ++rucksacks_len);
        assert(rucksacks != 0);
        rucksacks[rucksacks_len - 1] = rucksack;
    }

    unsigned priorities_sum;

    printf("=== PART 1 ===\n");
    priorities_sum = 0;
    for (size_t index = 0; index < rucksacks_len; index++) {
        rucksack = rucksacks[index];

        char item_type = rucksack.shared_item_type;
        char priority = get_item_type_priority(item_type);

        printf(
            "%.*s%.*s (shared item type: %c, priority: %d)\n",
            (int)rucksack.compartment1.len, rucksack.compartment1.ptr,
            (int)rucksack.compartment2.len, rucksack.compartment2.ptr,
            rucksack.shared_item_type,
            priority
        );

        priorities_sum += priority;
    }
    printf("priorities_sum=%d\n", priorities_sum);

    printf("=== PART 2 ===\n");
    priorities_sum = 0;
    for (size_t index = 0; index < rucksacks_len; index += 3) {
        struct Slice item_types1 = Rucksack_get_all_item_types(rucksacks[index]);
        struct Slice item_types2 = Rucksack_get_all_item_types(rucksacks[index + 1]);
        struct Slice item_types3 = Rucksack_get_all_item_types(rucksacks[index + 2]);
        char shared_item_type;
        for (size_t index1 = 0; index1 < item_types1.len; index1++) {
            char item_type_to_find = *(item_types1.ptr + index1);
            for (size_t index2 = 0; index2 < item_types2.len; index2++) {
                if (item_type_to_find == *(item_types2.ptr + index2)) {
                    for (size_t index3 = 0; index3 < item_types3.len; index3++) {
                        if (item_type_to_find == *(item_types3.ptr + index3)) {
                            shared_item_type = item_type_to_find;
                            goto part_2_shared_item_type_found;
                        }
                    }
                }
            }
        }
        assert(0);
        part_2_shared_item_type_found:
        (void)0; // some random thing to make the compiler happy

        char priority = get_item_type_priority(shared_item_type);
        priorities_sum += priority;
    }
    printf("priorities_sum=%d\n", priorities_sum);

    return 0;
}

