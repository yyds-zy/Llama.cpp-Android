CXX = c++
CXXFLAGS = -g -Wall -std=c++11

TARGET = hello_world

$(TARGET): $(TARGET).cpp
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(TARGET).cpp

.PHONY: clean

clean:
	rm -f $(TARGET)