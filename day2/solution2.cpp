#include <stdio.h>
#include <assert.h>
#include <stdint.h>

enum Outcome : uint8_t {
    Loss = 0,
    Draw = 3,
    Win = 6,
};

class HandShape {
    public:
        enum Value : uint8_t {
            Rock = 1,
            Paper = 2,
            Scissors = 3,
        };

        Value value;

        HandShape() {}

        HandShape(char letter) {
            switch (letter) {
                case 'A':
                case 'X':
                    this->value = Rock;
                    break;
                case 'B':
                case 'Y':
                    this->value = Paper;
                    break;
                case 'C':
                case 'Z':
                    this->value = Scissors;
                    break;
                default:
                    printf("HandShape() panic\n");
            }
        }

        Outcome play(Value other) {
            if (this->value == other)
                return Outcome::Draw;
            switch (this->value) {
                case Rock:
                    if (other == Paper)
                        return Outcome::Loss;
                    if (other == Scissors)
                        return Outcome::Win;
                case Paper:
                    if (other == Rock)
                        return Outcome::Win;
                    if (other == Scissors)
                        return Outcome::Loss;
                case Scissors:
                    if (other == Rock)
                        return Outcome::Loss;
                    if (other == Paper)
                        return Outcome::Win;
            }
            printf("play() panic\n");
            __builtin_unreachable();
        }
};

int main() {
    int score = 0;

    HandShape first;
    HandShape second;
   
    FILE* file = fopen("input", "r");
    char input[1];
    int index = 0;
    while (fread(&input, 1, 1, file)) {
        char letter = input[0];
        printf("letter=%c,index=%d\n", letter, index);
        switch (index % 4) {
            case 0: // letter (my opponent's hand shape)
                first = HandShape(letter);
                break;
            case 1: // space
                break;
            case 2: // letter (the way the round needs to end)
                    // > X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
                switch (letter) {
                    case 'X': // we need to lose
                        switch (first.value) {
                            case HandShape::Rock:
                                second.value = HandShape::Scissors;
                                break;
                            case HandShape::Paper:
                                second.value = HandShape::Rock;
                                break;
                            case HandShape::Scissors:
                                second.value = HandShape::Paper;
                                break;
                        }
                        printf("second is %d\n", second.value);
                        break;
                    case 'Y': // we need a draw
                        second = first;
                        break;
                    case 'Z': // we need a win
                        switch (first.value) {
                            case HandShape::Rock:
                                second.value = HandShape::Paper;
                                break;
                            case HandShape::Paper:
                                second.value = HandShape::Scissors;
                                break;
                            case HandShape::Scissors:
                                second.value = HandShape::Rock;
                                break;
                        }
                        break;
                }
                printf("%d VS %d results in %d\n", (uint8_t)first.value, (uint8_t)second.value, (uint8_t)first.play(second.value));
                score += (uint8_t)second.value;
                score += (uint8_t)second.play(first.value);
                printf("score: %d\n", score);
                break;
            case 3: // newline
                break;
        }
        index += 1; 
    }
}

