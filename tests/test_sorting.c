#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>
#include <cmocka.h>
#include "../include/sorting.h"

// Helper function to compare arrays
static void assert_sorted(int *sorted, int *expected, int size)
{
    for (int i = 0; i < size; i++)
    {
        assert_int_equal(sorted[i], expected[i]);
    }
}

// Test Quicksort
static void test_quicksort(void **state)
{
    (void)state;
    int arr[] = {5, 2, 9, 1, 5, 6};
    int expected[] = {1, 2, 5, 5, 6, 9};
    sort_array(arr, 6, "quicksort");
    assert_sorted(arr, expected, 6);
}

// Test Merge Sort
static void test_mergesort(void **state)
{
    (void)state;
    int arr[] = {10, 7, 8, 9, 1, 5};
    int expected[] = {1, 5, 7, 8, 9, 10};
    sort_array(arr, 6, "mergesort");
    assert_sorted(arr, expected, 6);
}

// Test Heap Sort
static void test_heapsort(void **state)
{
    (void)state;
    int arr[] = {3, 5, 1, 8, 2, 7};
    int expected[] = {1, 2, 3, 5, 7, 8};
    sort_array(arr, 6, "heapsort");
    assert_sorted(arr, expected, 6);
}

// Test Unknown Algorithm (Should Default to Quicksort)
static void test_unknown_algorithm(void **state)
{
    (void)state;
    int arr[] = {9, 3, 7, 4, 6, 1};
    int expected[] = {1, 3, 4, 6, 7, 9}; // Should default to quicksort
    sort_array(arr, 6, "bogus");
    assert_sorted(arr, expected, 6);
}

// Run all tests
int main(void)
{
    const struct CMUnitTest tests[] = {
        cmocka_unit_test(test_quicksort),
        cmocka_unit_test(test_mergesort),
        cmocka_unit_test(test_heapsort),
        cmocka_unit_test(test_unknown_algorithm),
    };
    return cmocka_run_group_tests(tests, NULL, NULL);
}
