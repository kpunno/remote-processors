/*

  image-adjust
  
  (C)2022 Seneca College of Applied Arts and Technology.
  Written by Chris Tyler. Licensed under the terms of the GPL verion 2.
  
*/

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/param.h>

// adjust_channels is where all the real action is
// this file is just scaffolding!
#include "adjust_channels.h"

// Using the STBI image reader/writer
// See https://github.com/nothings/stb
#define STBI_NO_LINEAR
#define STBI_NO_HDR
#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb_image_write.h>

int main(int argc, char *argv[]) {

	// ==================== Check arg count
	if (argc != 7) {
		dprintf(2, "\nUsage: %s input.jpg red green blue output.jpg count\nWhere red/green/blue are in the range 0.0-2.0\n", argv[0]);
		return 1;
	}

	// ==================== Load the image file (arg 1)
	int x, y, n;
	unsigned char *image = stbi_load(argv[1], 
		&x, &y, &n, 3);

	if (image == NULL) {
		dprintf(2, "Invalid argument or input image file did not load.\n");
		dprintf(2, "\nUsage: %s input.jpg red green blue output.jpg\nWhere red/green/blue are in the range 0.0-2.0\n", argv[0]);
		return 2;
	}
	printf("File '%s' loaded: %dx%d pixels, %d bytes per pixel.\n", argv[1], x, y, n);


	
	// ==================== Adjust the channels
	
	// Get arguments 2, 3, and 4; each should be a number in the range 0.0 .. 2.0
	// Yes this is ugly and should be improved, this is a quick & dirty test program :-)

	struct timeval startTime;
	struct timeval endTime;
	long int execution_uS = 0;

	float redarg   = MIN(2, MAX(0, strtof(argv[2],NULL)));
	float greenarg = MIN(2, MAX(0, strtof(argv[3],NULL)));
	float bluearg  = MIN(2, MAX(0, strtof(argv[4],NULL)));
	int   countarg = MAX(0, atoi(argv[6]));
	printf("Requested executions: %d\n", countarg);

	printf("Adjustments:\tred: %8.6f   green: %8.6f   blue: %8.6f\n", redarg, greenarg, bluearg);
	
	gettimeofday(&startTime, NULL);
	for (int i = 0; i < countarg; i++) {
		adjust_channels(image, x, y, redarg, greenarg, bluearg);
	};
	gettimeofday(&endTime, NULL);

	execution_uS = (endTime.tv_sec*(int)1e6+endTime.tv_usec)-(startTime.tv_sec*(int)1e6+startTime.tv_usec);

	printf("Time to execute adjust_channels() %d times: \e[41m\e[97m %f mS \e(B\e[m (%f S)\n", countarg, (float) execution_uS/1000, (float) execution_uS/(int)1e6);

	// ==================== Save the resulting file (jpg) (arg 5)
	stbi_write_jpg(argv[5], x, y, n, image, 90);
}

