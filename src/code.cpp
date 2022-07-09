#include <cpp11.hpp>
using namespace cpp11;

[[cpp11::register]]
void fun() {}

#include <stdio.h>
#include <tensorflow/c/c_api.h>

[[cpp11::register]]
int version() {
  printf("Hello from TensorFlow C library version %s\n", TF_Version());
  return 0;
}
