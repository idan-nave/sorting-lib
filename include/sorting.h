#ifndef SORTING_H
#define SORTING_H

#define SORTING_LIB_VERSION "1.0.0"

void sort_array(int arr[], int size, const char *algorithm);
void quicksort(int arr[], int low, int high);
void merge_sort(int arr[], int left, int right);
void heap_sort(int arr[], int n);

#endif
