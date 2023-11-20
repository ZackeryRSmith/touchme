#include <stdio.h>
extern int touchId(char *);

int main() {
    printf("%d", touchId("random reason"));
    return 0;
}
