// Taken from
// https://github.com/gunrock/essentials/blob/master/include/gunrock/util/timer.hxx

#pragma once

namespace util {

typedef float sec_t;
typedef float millisec_t;
typedef float microsec_t;

struct DeviceTimer {
  millisec_t time;

  DeviceTimer() {
    cudaEventCreate(&start_);
    cudaEventCreate(&stop_);
    cudaEventRecord(start_);
  }

  ~DeviceTimer() {
    cudaEventDestroy(start_);
    cudaEventDestroy(stop_);
  }

  void start(cudaStream_t stream = 0) { cudaEventRecord(start_, stream); }

  millisec_t stop(cudaStream_t stream = 0) {
    cudaEventRecord(stop_, stream);
    cudaEventSynchronize(stop_);
    cudaEventElapsedTime(&time, start_, stop_);

    return milliseconds();
  }

  sec_t seconds() { return time * 1e-3; }
  millisec_t milliseconds() { return time; }
  microsec_t microseconds() { return time * 1e3; }

private:
  cudaEvent_t start_, stop_;
};

} // namespace util
