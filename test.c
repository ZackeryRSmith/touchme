#include <stdio.h>
extern int touchId(char *);
extern int isAvailable();

int main() {
    printf("%d\n", isAvailable());
    printf("%d\n", touchId("random reason"));
    return 0;
}
