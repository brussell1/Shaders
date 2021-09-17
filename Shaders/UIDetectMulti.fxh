//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//UIDetectMulti header file
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*
Description:

PIXELNUMBER                     //total number of pixels used for UI detection
UIPixelCoord[PIXELNUMBER]       //the UI pixels screen space coordinates (top left is 0,0) and UI number;
{
    float3(x1,y1,UI1),
    float3(x2,y2,UI1),
    float3(x3,y3,UI1),
    float3(x4,y4,UI2),
    float3(x5,y5,UI3),
    ...
}
UIPixelRGB[PIXELNUMBER]         //the UI pixels RGB values
{
    float3(Red1,Green1,Blue1),
    float3(Red2,Green2,Blue2),
    ...
}
*/

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//Game: The Witcher 3
//Resolution: 1920x1080

#ifndef UIDetect_USE_RGB_MASK
    #define UIDetect_USE_RGB_MASK  3       // [1-5] Enable RGB UI mask (description above) 
#endif

#ifndef UIDetect_INVERT
    #define UIDetect_INVERT        0       // [0 or 1] Enable Inverted Mode (only show effects when 
#endif                                     // UI is visible)

#ifndef UIDetect_EveryPixel
	#define UIDetect_EveryPixel		0		// [0 or 1] 0 means that all pixels with same .z value must match, 
#endif                                      // 1 means that only 1 pixel must match.

#define PIXELNUMBER 38

static const float3 UIPixelCoord_UINr[PIXELNUMBER]=
{
	float3(743,168,1),
	float3(743,168,1),
	float3(743,168,1),	
	float3(743,168,1),
	float3(743,168,1),
	float3(743,168,1),	
	float3(1850,47,2),
	float3(1850,47,2),
	float3(1839,30,2),
	float3(184,65,3),
	float3(92,852,4),
	float3(103,882,4),
	float3(112,912,4),
	float3(122,944,4),	
	float3(116,841,4),
	float3(1169,310,5),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(1637,68,6),
	float3(381,852,7),
	float3(392,882,7),
	float3(402,912,7),
	float3(412,945,7),
	float3(416,853,7),
	float3(773,946,8),
	float3(773,946,8),
	float3(172,203,9),
	float3(488,1018,10),
	float3(1850,47,11),
	float3(184,65,12),
	float3(488,1018,13),
	float3(1850,47,14),
	float3(184,65,15),
};

static const float3 UIPixelRGB[PIXELNUMBER]=
{
	float3(27,19,15),
	float3(68,66,68),
	float3(42,32,15),
	float3(26,19,15),
	float3(67,66,68),
	float3(41,32,15),
	float3(142,132,110),
	float3(233,233,233),
	float3(155,105,56),
	float3(77,77,77),
	float3(25,25,25),
	float3(25,25,25),
	float3(25,25,25),
	float3(25,25,25),
	float3(5,6,5),
	float3(23,59,70),
	float3(206,169,67),
	float3(174,160,76),
	float3(138,150,166),
	float3(204,206,191),
	float3(253,243,213),
	float3(132,134,140),
	float3(213,201,170),
	float3(167,146,100),	
	float3(25,25,25),
	float3(25,25,25),
	float3(25,25,25),
	float3(25,25,25),
	float3(5,6,5),
	float3(129,117,95),
	float3(131,119,96),
	float3(201,171,138),
	float3(25,25,25),
	float3(142,132,110),
	float3(77,77,77),
	float3(25,25,25),
	float3(142,132,110),
	float3(77,77,77),
};
