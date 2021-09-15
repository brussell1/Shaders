//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// UIDetect by brussell
// v. 2.1.0
// License: CC BY 4.0
//
// Multi-Mask Variant By Kaiser
// v. 1.0.0
// License: CC By 4.0
//
// UIDetect is configured via the file UIDetect.fxh. Please look
// there for a full description and usage of this shader.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "ReShadeUI.fxh"

uniform float fPixelPosX < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Pixel X-Position";
    ui_category = "Show Pixel";
    ui_min = 0; ui_max = BUFFER_WIDTH;
    ui_step = 1;
> = 100;

uniform float fPixelPosY < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Pixel Y-Position";
    ui_category = "Show Pixel";
    ui_min = 0; ui_max = BUFFER_HEIGHT;
    ui_step = 1;
> = 100;

uniform float toleranceR < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Red Color Tolerance";
    ui_category = "Color Tolerances";
	ui_min = 0; ui_max = 255;
    ui_step = 1;
> = 1;

uniform float toleranceG < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Green Color Tolerance";
    ui_category = "Color Tolerances";
	ui_min = 0; ui_max = 255;
    ui_step = 1;
> = 1;

uniform float toleranceB < __UNIFORM_SLIDER_FLOAT1
    ui_label = "Blue Color Tolerance";
    ui_category = "Color Tolerances";
	ui_min = 0; ui_max = 255;
    ui_step = 1;
> = 1;

#include "ReShade.fxh"
#include "UIDetect.fxh"

//textures and samplers
texture texColorOrig { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler ColorOrig { Texture = texColorOrig; };

texture texUIDetectMask <source="UIDetectMaskRGB.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
sampler UIDetectMask { Texture = texUIDetectMask; };

texture texUIDetect { Width = 1; Height = 1; Format = RGBA8; };
sampler UIDetect { Texture = texUIDetect; };

#if (UIDetect_USE_RGB_MASK > 1)
	texture texUIDetectMask2 <source="UIDetectMaskRGB2.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
  sampler UIDetectMask2 { Texture = texUIDetectMask2; };
	texture texUIDetect2 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetect2 { Texture = texUIDetect2; };
#endif

#if (UIDetect_USE_RGB_MASK > 2)
	texture texUIDetectMask3 <source="UIDetectMaskRGB3.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
  sampler UIDetectMask3 { Texture = texUIDetectMask3; };
	texture texUIDetect3 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetect3 { Texture = texUIDetect3; };
#endif

#if (UIDetect_USE_RGB_MASK > 3)
	texture texUIDetectMask4 <source="UIDetectMaskRGB4.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
  sampler UIDetectMask4 { Texture = texUIDetectMask4; };
	texture texUIDetect4 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetect4 { Texture = texUIDetect4; };
#endif

#if (UIDetect_USE_RGB_MASK > 4)
	texture texUIDetectMask5 <source="UIDetectMaskRGB5.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
  sampler UIDetectMask5 { Texture = texUIDetectMask5; };
	texture texUIDetect5 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetect5 { Texture = texUIDetect5; };
#endif

//pixel shaders
float3 PS_ShowPixel(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    float2 pixelCoord = float2(fPixelPosX, fPixelPosY) * BUFFER_PIXEL_SIZE;
    float3 pixelColor = tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).xyz;
    return pixelColor;
}

float4 PS_UIDetect(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
  float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	float3 uicolors;
	int uinumber = 0;
  bool uiDetected1 = false;
  bool uiDetected2 = false;
  bool uiDetected3 = false;

    for (int i=0; i < 3; i++){
		  pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
      pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
      uiPixelColor = UIPixelRGB[uinumber].rgb;
      diff = abs(pixelColor - uiPixelColor);
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 1) uiDetected1 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 1) uiDetected1 = false;
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 2) uiDetected2 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 2) uiDetected2 = false;	
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 3) uiDetected3 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 3) uiDetected3 = false;
		  if (uiDetected1 == true){uicolors.r = 0;}
		  if (uiDetected1 == false){uicolors.r = 1;}
		  if (uiDetected2 == true){uicolors.g = 0;}
		  if (uiDetected2 == false){uicolors.g = 1;}
		  if (uiDetected3 == true){uicolors.b = 0;}
		  if (uiDetected3 == false){uicolors.b = 1;}
		  if (uinumber == 3) {return float4(uicolors, 1);};
		  uinumber += 1;
	  }
	return float4(uicolors, 1);
}

#if (UIDetect_USE_RGB_MASK > 1)
float4 PS_UIDetect2(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
  float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	float3 uicolors;
	int uinumber = 3;
  bool uiDetected1 = false;
  bool uiDetected2 = false;
  bool uiDetected3 = false;

    for (int i=0; i < 3; i++){
		  pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
      pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
      uiPixelColor = UIPixelRGB[uinumber].rgb;
      diff = abs(pixelColor - uiPixelColor);
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 4) uiDetected1 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 4) uiDetected1 = false;
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 5) uiDetected2 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 5) uiDetected2 = false;	
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 6) uiDetected3 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 6) uiDetected3 = false;
		  if (uiDetected1 == true){uicolors.r = 0;}
		  if (uiDetected1 == false){uicolors.r = 1;}
		  if (uiDetected2 == true){uicolors.g = 0;}
		  if (uiDetected2 == false){uicolors.g = 1;}
		  if (uiDetected3 == true){uicolors.b = 0;}
		  if (uiDetected3 == false){uicolors.b = 1;}
		  if (uinumber == 6) {return float4(uicolors, 1);};
		  uinumber += 1;
	  }
	return float4(uicolors, 1);
}
#endif
#if (UIDetect_USE_RGB_MASK > 2)
float4 PS_UIDetect3(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
  float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	float3 uicolors;
	int uinumber = 6;
  bool uiDetected1 = false;
  bool uiDetected2 = false;
  bool uiDetected3 = false;

    for (int i=0; i < 3; i++){
	    pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
      pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
      uiPixelColor = UIPixelRGB[uinumber].rgb;
      diff = abs(pixelColor - uiPixelColor);
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 7) uiDetected1 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 7) uiDetected1 = false;
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 8) uiDetected2 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 8) uiDetected2 = false;	
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 9) uiDetected3 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 9) uiDetected3 = false;
		  if (uiDetected1 == true){uicolors.r = 0;}
		  if (uiDetected1 == false){uicolors.r = 1;}
		  if (uiDetected2 == true){uicolors.g = 0;}
		  if (uiDetected2 == false){uicolors.g = 1;}
		  if (uiDetected3 == true){uicolors.b = 0;}
		  if (uiDetected3 == false){uicolors.b = 1;}
		  if (uinumber == 9) {return float4(uicolors, 1);};
		  uinumber += 1;
	  }
	return float4(uicolors, 1);
}
#endif
#if (UIDetect_USE_RGB_MASK > 3)
float4 PS_UIDetect4(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
  float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	float3 uicolors;
	int uinumber = 9;
  bool uiDetected1 = false;
  bool uiDetected2 = false;
  bool uiDetected3 = false;

    for (int i=0; i < 3; i++){
		  pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
      pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
      uiPixelColor = UIPixelRGB[uinumber].rgb;
      diff = abs(pixelColor - uiPixelColor);
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 10) uiDetected1 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 10) uiDetected1 = false;
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 11) uiDetected2 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 11) uiDetected2 = false;	
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 12) uiDetected3 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 12) uiDetected3 = false;
		  if (uiDetected1 == true){uicolors.r = 0;}
		  if (uiDetected1 == false){uicolors.r = 1;}
		  if (uiDetected2 == true){uicolors.g = 0;}
		  if (uiDetected2 == false){uicolors.g = 1;}
		  if (uiDetected3 == true){uicolors.b = 0;}
		  if (uiDetected3 == false){uicolors.b = 1;}
		  if (uinumber == 12) {return float4(uicolors, 1);};
		  uinumber += 1;
	  }
	return float4(uicolors, 1);
}
#endif
#if (UIDetect_USE_RGB_MASK > 4)
float4 PS_UIDetect5(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
  float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	float3 uicolors;
	int uinumber = 12;
  bool uiDetected1 = false;
  bool uiDetected2 = false;
  bool uiDetected3 = false;

    for (int i=0; i < 3; i++){
		  pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
      pixelColor = round(tex2Dlod(ReShade::BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
      uiPixelColor = UIPixelRGB[uinumber].rgb;
      diff = abs(pixelColor - uiPixelColor);
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 13) uiDetected1 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 13) uiDetected1 = false;
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 14) uiDetected2 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 14) uiDetected2 = false;	
		  if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 15) uiDetected3 = true;
		  if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 15) uiDetected3 = false;
		  if (uiDetected1 == true){uicolors.r = 0;}
		  if (uiDetected1 == false){uicolors.r = 1;}
		  if (uiDetected2 == true){uicolors.g = 0;}
		  if (uiDetected2 == false){uicolors.g = 1;}
		  if (uiDetected3 == true){uicolors.b = 0;}
		  if (uiDetected3 == false){uicolors.b = 1;}
		  if (uinumber == 15) {return float4(uicolors, 1);};
		  uinumber += 1;
	  }
	return float4(uicolors, 1);
}
#endif
float4 PS_StoreColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    return tex2D(ReShade::BackBuffer, texcoord);
}

float4 PS_ShowOrigColor(float4 pos : SV_position, float2 texcoord : TEXCOORD) : SV_Target
{
  float4 colorOrig = tex2D(ColorOrig, texcoord);
	return colorOrig;
}

float4 PS_RestoreColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    #if (UIDetect_INVERT == 0)
        float3 colorOrig = tex2D(ColorOrig, texcoord).rgb;
        float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #else
        float3 color = tex2D(ColorOrig, texcoord).rgb;
        float3 colorOrig = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #endif
  float3 uiMask = tex2D(UIDetectMask, texcoord).rgb;
	float3 mask;
  float3 ui = tex2D(UIDetect, float2(0,0)).rgb;
	if (ui.r == 0)		{mask = uiMask.b; 		color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)		{mask = uiMask.g; 		color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)		{mask = uiMask.r; 		color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}

#if (UIDetect_USE_RGB_MASK > 1)
float4 PS_RestoreColor2(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    #if (UIDetect_INVERT == 0)
        float3 colorOrig = tex2D(ColorOrig, texcoord).rgb;
        float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #else
        float3 color = tex2D(ColorOrig, texcoord).rgb;
        float3 colorOrig = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #endif
  float3 uiMask = tex2D(UIDetectMask2, texcoord).rgb;
	float3 mask;
  float3 ui = tex2D(UIDetect2, float2(0,0)).rgb;
	if (ui.r == 0)		{mask = uiMask.b; 		color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)		{mask = uiMask.g; 		color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)		{mask = uiMask.r; 		color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif
#if (UIDetect_USE_RGB_MASK > 2)
float4 PS_RestoreColor3(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    #if (UIDetect_INVERT == 0)
        float3 colorOrig = tex2D(ColorOrig, texcoord).rgb;
        float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #else
        float3 color = tex2D(ColorOrig, texcoord).rgb;
        float3 colorOrig = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #endif
  float3 uiMask = tex2D(UIDetectMask3, texcoord).rgb;
	float3 mask;
  float3 ui = tex2D(UIDetect3, float2(0,0)).rgb;
	if (ui.r == 0)		{mask = uiMask.b; 		color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)		{mask = uiMask.g; 		color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)		{mask = uiMask.r; 		color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif
#if (UIDetect_USE_RGB_MASK > 3)
float4 PS_RestoreColor4(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    #if (UIDetect_INVERT == 0)
        float3 colorOrig = tex2D(ColorOrig, texcoord).rgb;
        float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #else
        float3 color = tex2D(ColorOrig, texcoord).rgb;
        float3 colorOrig = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #endif
  float3 uiMask = tex2D(UIDetectMask4, texcoord).rgb;
	float3 mask;
  float3 ui = tex2D(UIDetect4, float2(0,0)).rgb;
	if (ui.r == 0)		{mask = uiMask.b; 		color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)		{mask = uiMask.g; 		color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)		{mask = uiMask.r; 		color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif
#if (UIDetect_USE_RGB_MASK > 4)
float4 PS_RestoreColor5(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    #if (UIDetect_INVERT == 0)
        float3 colorOrig = tex2D(ColorOrig, texcoord).rgb;
        float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #else
        float3 color = tex2D(ColorOrig, texcoord).rgb;
        float3 colorOrig = tex2D(ReShade::BackBuffer, texcoord).rgb;
    #endif
  float3 uiMask = tex2D(UIDetectMask5, texcoord).rgb;
	float3 mask;
  float3 ui = tex2D(UIDetect5, float2(0,0)).rgb;
	if (ui.r == 0)		{mask = uiMask.b; 		color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)		{mask = uiMask.g; 		color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)		{mask = uiMask.r; 		color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif

//techniques
technique UIDetect_ShowPixel
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_ShowPixel;
    }
}

technique UIDetect
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UIDetect;
        RenderTarget = texUIDetect;
    }
#if (UIDetect_USE_RGB_MASK > 1)
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UIDetect2;
        RenderTarget = texUIDetect2;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 2)
	pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UIDetect3;
        RenderTarget = texUIDetect3;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 3)
	pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UIDetect4;
        RenderTarget = texUIDetect4;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 4)
	pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_UIDetect5;
        RenderTarget = texUIDetect5;
    }
#endif
}

technique UIDetect_Before
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_StoreColor;
        RenderTarget = texColorOrig;
    }
}

technique UIDetect_After
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_RestoreColor;
    }
#if (UIDetect_USE_RGB_MASK > 1)
    pass {
        VertexShader = PostProcessVS;
		PixelShader = PS_RestoreColor2;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 2)
    pass {
        VertexShader = PostProcessVS;
		PixelShader = PS_RestoreColor3;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 3)
    pass {
        VertexShader = PostProcessVS;
		PixelShader = PS_RestoreColor4;
    }
#endif
#if (UIDetect_USE_RGB_MASK > 4)
    pass {
        VertexShader = PostProcessVS;
		PixelShader = PS_RestoreColor5;
    }
#endif
}

technique UIDetect_ShowOriginalColor
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_ShowOrigColor;
    }
}