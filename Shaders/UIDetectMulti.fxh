//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//UIDetect header file
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
    #define UIDetect_USE_RGB_MASK  1       // [1-5] Enable RGB UI mask (description above) 
#endif

#define PIXELNUMBER 3

static const float3 UIPixelCoord_UINr[PIXELNUMBER]=
{
	float3(0,0,1),
	float3(0,0,2),
	float3(0,0,3),
};

static const float3 UIPixelRGB[PIXELNUMBER]=
{
	float3(255,255,255),
	float3(255,255,255),
	float3(255,255,255),
};
