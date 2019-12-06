import numpy

def dominant_frequency(x, sf):
  # x: vector with data values
  # sf: sample frequency
  fourier = numpy.fft.fft(x)
  frequencies = numpy.fft.fftfreq(len(x), 1/sf)
  magnitudes = abs(fourier[numpy.where(frequencies > 0)])
  peak_frequency = frequencies[numpy.argmax(magnitudes)]
  return peak_frequency
