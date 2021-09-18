//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// UIDetect by brussell
// v. 2.1.0
// License: CC BY 4.0
//
// Multi-Mask Variant By Kaiser
// v. 1.5.0
// License: CC By 4.0
//
// UIDetect is configured via the file UIDetectMulti.fxh. Please look
// there for a full description and usage of this shader.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "ReShadeUI.fxh"

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

#if (UIDM_DIAGNOSTICS == 1)
	uniform float fPixelPosX < __UNIFORM_SLIDER_FLOAT1
		ui_label = "Pixel X-Position";
		ui_category = "Pixel Selection";
		ui_min = 0; ui_max = BUFFER_WIDTH;
		ui_step = 1;
	> = 100;
	
	uniform float fPixelPosY < __UNIFORM_SLIDER_FLOAT1
		ui_label = "Pixel Y-Position";
		ui_category = "Pixel Selection";
		ui_min = 0; ui_max = BUFFER_HEIGHT;
		ui_step = 1;
	> = 100;
	
	uniform bool BlackFont <
		ui_label = "Font color";
		ui_tooltip = "Check for Black font, Uncheck for White font";
		ui_category = "Pixel Selection";
	> = true;
#endif

#include "ReShade.fxh"
#include "UIDetectMulti.fxh"
#include "DrawText.fxh"

#undef BUFFER_PIXEL_SIZE
#define BUFFER_PIXEL_SIZE float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)
texture texBackBuffer : COLOR;
sampler BackBuffer { Texture = texBackBuffer; };

//textures and samplers
texture texColorBeforeMulti { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
sampler ColorBeforeMulti { Texture = texColorBeforeMulti; };
texture texUIDetectMaskMulti <source="UIDETECTMASKRGBMULTI.png";> { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
sampler UIDetectMaskMulti { Texture = texUIDetectMaskMulti; };
texture texUIDetectMulti { Width = 1; Height = 1; Format = RGBA8; };
sampler UIDetectMulti { Texture = texUIDetectMulti; };

#if (UIDM_DIAGNOSTICS == 1)
	texture textextcolor { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
	sampler textcolor { Texture = textextcolor; };
	texture textextcolor2 { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
	sampler textcolor2 { Texture = textextcolor2; };
	texture texColorOrigMulti { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; };
	sampler ColorOrigMulti { Texture = texColorOrigMulti; };
#endif

#if (UIDM_MASK_COUNT > 1)
	texture texUIDetectMaskMulti2 <source="UIDETECTMASKRGBMULTI2.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
	sampler UIDetectMaskMulti2 { Texture = texUIDetectMaskMulti2; };
	texture texUIDetectMulti2 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetectMulti2 { Texture = texUIDetectMulti2; };
#endif

#if (UIDM_MASK_COUNT > 2)
	texture texUIDetectMaskMulti3 <source="UIDETECTMASKRGBMULTI3.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
	sampler UIDetectMaskMulti3 { Texture = texUIDetectMaskMulti3; };
	texture texUIDetectMulti3 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetectMulti3 { Texture = texUIDetectMulti3; };
#endif

#if (UIDM_MASK_COUNT > 3)
	texture texUIDetectMaskMulti4 <source="UIDETECTMASKRGBMULTI4.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
	sampler UIDetectMaskMulti4 { Texture = texUIDetectMaskMulti4; };
	texture texUIDetectMulti4 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetectMulti4 { Texture = texUIDetectMulti4; };
#endif

#if (UIDM_MASK_COUNT > 4)
	texture texUIDetectMaskMulti5 <source="UIDETECTMASKRGBMULTI5.png";>{ Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format=RGBA8; };
	sampler UIDetectMaskMulti5 { Texture = texUIDetectMaskMulti5; };
	texture texUIDetectMulti5 { Width = 1; Height = 1; Format = RGBA8; };
	sampler UIDetectMulti5 { Texture = texUIDetectMulti5; };
#endif

//pixel shaders
#if (UIDM_DIAGNOSTICS == 1)
	float4 State_Pixel_Color(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float res;
		float2 pixelCoord = float2(fPixelPosX, fPixelPosY) * BUFFER_PIXEL_SIZE;
		float3 pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
		uint Red = trunc(pixelColor.x);
		uint Green = trunc(pixelColor.y);
		uint Blue = trunc(pixelColor.z);
		int Red3 = (Red - (Red % 100)) / 100;
		int Red2 = ((Red % 100) - (Red % 10)) / 10;
		int Red1 = Red % 10;
		int Green3 = (Green - (Green % 100)) / 100;
		int Green2 = ((Green % 100) - (Green % 10)) / 10;
		int Green1 = Green % 10;
		int Blue3 = (Blue - (Blue % 100)) / 100;
		int Blue2 = ((Blue % 100) - (Blue % 10)) / 10;
		int Blue1 = Blue % 10;
		int line0[10]  = { __R, __E, __D, __Colon, __Space, __Space, __Space, Red3 + 16, Red2 + 16, Red1 + 16 }; //Red
		int line1[10]  = { __G, __R, __E, __E, __N, __Colon, __Space, Green3 + 16, Green2 + 16, Green1 + 16 }; //Green
		int line2[10]  = { __B, __L, __U, __E, __Colon, __Space, __Space, Blue3 + 16, Blue2 + 16, Blue1 + 16 }; //Blue
		DrawText_String(float2(800.0 , 100.0), 50, 1, texcoord,  line0, 10, res);
		DrawText_String(float2(800.0 , 134.0), 50, 1, texcoord,  line1, 10, res);
		DrawText_String(float2(800.0 , 168.0), 50, 1, texcoord,  line2, 10, res);
		return res;
	}
	
	float4 Fontinvert(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 colors = tex2D(textcolor, texcoord).rgb;
		return float4(1.0 - colors, 1.0);
	}
	
	float3 Crosshair(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 color = 0;
		float3 crosshair = 1;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
		float2 pixelCoord = float2(fPixelPosX, fPixelPosY) * BUFFER_PIXEL_SIZE;
		int Xtest = 0;
		int Ytest = 0;
		if (abs((texcoord.x / BUFFER_PIXEL_SIZE.x) - (pixelCoord.x / BUFFER_PIXEL_SIZE.x)) < 0.5) Xtest = 1;
		if (abs((texcoord.y / BUFFER_PIXEL_SIZE.y) - (pixelCoord.y / BUFFER_PIXEL_SIZE.y)) < 0.5) Ytest = 1;
		if (Xtest == 1 && Ytest == 1){ Xtest = 0; Ytest = 0;}
		color = lerp(color, crosshair, Xtest);
		color = lerp(color, crosshair, Ytest);
		float mask = color.x;
		color = lerp(colorOrig, color, mask);
		return color;
	}
	
	float4 FontTransparancy(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 color;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
		float mask;
		
		if (BlackFont == true){
			color = tex2D(textcolor, texcoord).rgb;
			mask = saturate(tex2D(textcolor, texcoord).r);
		}
		if (BlackFont == false){
			color = tex2D(textcolor2, texcoord).rgb;
			mask = saturate(1.0 - tex2D(textcolor2, texcoord).r);
		}
		
		color = lerp(colorOrig, color, mask);
		return float4(color, 1.0);
	}
	
	float4 PS_ShowOrigColor(float4 pos : SV_position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float4 colorOrig = tex2D(ColorOrigMulti, texcoord);
		return colorOrig;
	}
#endif

float4 PS_UIDetect(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float3 pixelColor, uiPixelColor, diff;
	float2 pixelCoord;
	int uinumber;
	
	#if (UIDM_EVERYPIXEL == 0)
		float3 uiDetected2 = 0;
		float3 uicolors = 1;
		float3 uiDetected = 0;
	#else
		float3 uiDetected2 = 1;
		float3 uicolors = 0;
		float3 uiDetected = 1;
	#endif
	
	for (int i=0; i < PIXELNUMBER; i++){
		if (UIPixelCoord_UINr[i].z == 1){uinumber = i; break;}
	}
	
	for (int i=0; i < 3; i++){
		pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
		pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
		uiPixelColor = UIPixelRGB[uinumber].rgb;
		diff = abs(pixelColor - uiPixelColor);
		#if (UIDM_EVERYPIXEL == 0)
			if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 1) uiDetected.x = 1;
			if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 2) uiDetected.y = 1;	
			if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 3) uiDetected.z = 1;
			if (uiDetected.x == 1){uiDetected2.x = 1;}
			if (uiDetected.y == 1){uiDetected2.y = 1;}
			if (uiDetected.z == 1){uiDetected2.z = 1;}
			if (uiDetected2.x == 1){uicolors.r = 0;}
			if (uiDetected2.y == 1){uicolors.g = 0;}
			if (uiDetected2.z == 1){uicolors.b = 0;}
		#else
			if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 1) uiDetected.x = 0;
			if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 2) uiDetected.y = 0;
			if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 3) uiDetected.z = 0;
			if (uiDetected.x == 0 && UIPixelCoord_UINr[uinumber].z == 1){uiDetected2.x = 0;}
			if (uiDetected.y == 0 && UIPixelCoord_UINr[uinumber].z == 2){uiDetected2.y = 0;}
			if (uiDetected.z == 0 && UIPixelCoord_UINr[uinumber].z == 3){uiDetected2.z = 0;}
			if (uiDetected2.x == 0){uicolors.r = 1;}
			if (uiDetected2.y == 0){uicolors.g = 1;}
			if (uiDetected2.z == 0){uicolors.b = 1;}
		#endif
		if (uinumber < PIXELNUMBER - 1){
			if (UIPixelCoord_UINr[uinumber].z == UIPixelCoord_UINr[uinumber + 1].z){i -= 1;};
		}
		if (i == 3) {return float4(uicolors, 1);};
		uinumber += 1;
	  }
	return float4(uicolors, 1);
}

#if (UIDM_MASK_COUNT > 1)
	float4 PS_UIDetect2(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 pixelColor, uiPixelColor, diff;
		float2 pixelCoord;
		int uinumber;
		
		#if (UIDM_EVERYPIXEL == 0)
			float3 uiDetected2 = 0;
			float3 uicolors = 1;
			float3 uiDetected = 0;
		#else
			float3 uiDetected2 = 1;
			float3 uicolors = 0;
			float3 uiDetected = 1;
		#endif
		
		for (int i=0; i < PIXELNUMBER; i++){
			if (UIPixelCoord_UINr[i].z == 4){uinumber = i; break;}
		}  
	
		for (int i=0; i < 3; i++){
			pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
			pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
			uiPixelColor = UIPixelRGB[uinumber].rgb;
			diff = abs(pixelColor - uiPixelColor);
			#if (UIDM_EVERYPIXEL == 0)
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 4) uiDetected.x = 1;
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 5) uiDetected.y = 1;	
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 6) uiDetected.z = 1;
				if (uiDetected.x == 1){uiDetected2.x = 1;}
				if (uiDetected.y == 1){uiDetected2.y = 1;}
				if (uiDetected.z == 1){uiDetected2.z = 1;}
				if (uiDetected2.x == 1){uicolors.r = 0;}
				if (uiDetected2.y == 1){uicolors.g = 0;}
				if (uiDetected2.z == 1){uicolors.b = 0;}
			#else
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 4) uiDetected.x = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 5) uiDetected.y = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 6) uiDetected.z = 0;
				if (uiDetected.x == 0 && UIPixelCoord_UINr[uinumber].z == 4){uiDetected2.x = 0;}
				if (uiDetected.y == 0 && UIPixelCoord_UINr[uinumber].z == 5){uiDetected2.y = 0;}
				if (uiDetected.z == 0 && UIPixelCoord_UINr[uinumber].z == 6){uiDetected2.z = 0;}
				if (uiDetected2.x == 0){uicolors.r = 1;}
				if (uiDetected2.y == 0){uicolors.g = 1;}
				if (uiDetected2.z == 0){uicolors.b = 1;}
			#endif
			if (uinumber < PIXELNUMBER - 1){
				if (UIPixelCoord_UINr[uinumber].z == UIPixelCoord_UINr[uinumber + 1].z){i -= 1;};
			}
			if (i == 3) {return float4(uicolors, 1);};
			uinumber += 1;
		}
		return float4(uicolors, 1);
	}
#endif

#if (UIDM_MASK_COUNT > 2)
	float4 PS_UIDetect3(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 pixelColor, uiPixelColor, diff;
		float2 pixelCoord;
		int uinumber;
		
		#if (UIDM_EVERYPIXEL == 0)
			float3 uiDetected2 = 0;
			float3 uicolors = 1;
			float3 uiDetected = 0;
		#else
			float3 uiDetected2 = 1;
			float3 uicolors = 0;
			float3 uiDetected = 1;
		#endif
	
		for (int i=0; i < PIXELNUMBER; i++){
			if (UIPixelCoord_UINr[i].z == 7){uinumber = i; break;}
		}
	
		for (int i=0; i < 3; i++){
			pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
			pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
			uiPixelColor = UIPixelRGB[uinumber].rgb;
			diff = abs(pixelColor - uiPixelColor);
			#if (UIDM_EVERYPIXEL == 0)
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 7) uiDetected.x = 1;
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 8) uiDetected.y = 1;	
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 9) uiDetected.z = 1;
				if (uiDetected.x == 1){uiDetected2.x = 1;}
				if (uiDetected.y == 1){uiDetected2.y = 1;}
				if (uiDetected.z == 1){uiDetected2.z = 1;}
				if (uiDetected2.x == 1){uicolors.r = 0;}
				if (uiDetected2.y == 1){uicolors.g = 0;}
				if (uiDetected2.z == 1){uicolors.b = 0;}
			#else
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 7) uiDetected.x = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 8) uiDetected.y = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 9) uiDetected.z = 0;
				if (uiDetected.x == 0 && UIPixelCoord_UINr[uinumber].z == 7){uiDetected2.x = 0;}
				if (uiDetected.y == 0 && UIPixelCoord_UINr[uinumber].z == 8){uiDetected2.y = 0;}
				if (uiDetected.z == 0 && UIPixelCoord_UINr[uinumber].z == 9){uiDetected2.z = 0;}
				if (uiDetected2.x == 0){uicolors.r = 1;}
				if (uiDetected2.y == 0){uicolors.g = 1;}
				if (uiDetected2.z == 0){uicolors.b = 1;}
			#endif
			if (uinumber < PIXELNUMBER - 1){
				if (UIPixelCoord_UINr[uinumber].z == UIPixelCoord_UINr[uinumber + 1].z){i -= 1;};
			}
			if (i == 3) {return float4(uicolors, 1);};
			uinumber += 1;
		}
		return float4(uicolors, 1);
	}
#endif

#if (UIDM_MASK_COUNT > 3)
	float4 PS_UIDetect4(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 pixelColor, uiPixelColor, diff;
		float2 pixelCoord;
		int uinumber;
		
		#if (UIDM_EVERYPIXEL == 0)
			float3 uiDetected2 = 0;
			float3 uicolors = 1;
			float3 uiDetected = 0;
		#else
			float3 uiDetected2 = 1;
			float3 uicolors = 0;
			float3 uiDetected = 1;
		#endif
	
		for (int i=0; i < PIXELNUMBER; i++){
			if (UIPixelCoord_UINr[i].z == 10){uinumber = i; break;}
		}
	
		for (int i=0; i < 3; i++){
			pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
			pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
			uiPixelColor = UIPixelRGB[uinumber].rgb;
			diff = abs(pixelColor - uiPixelColor);
			#if (UIDM_EVERYPIXEL == 0)
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 10) uiDetected.x = 1;
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 11) uiDetected.y = 1;	
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 12) uiDetected.z = 1;
				if (uiDetected.x == 1){uiDetected2.x = 1;}
				if (uiDetected.y == 1){uiDetected2.y = 1;}
				if (uiDetected.z == 1){uiDetected2.z = 1;}
				if (uiDetected2.x == 1){uicolors.r = 0;}
				if (uiDetected2.y == 1){uicolors.g = 0;}
				if (uiDetected2.z == 1){uicolors.b = 0;}
			#else
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 10) uiDetected.x = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 11) uiDetected.y = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 12) uiDetected.z = 0;
				if (uiDetected.x == 0 && UIPixelCoord_UINr[uinumber].z == 10){uiDetected2.x = 0;}
				if (uiDetected.y == 0 && UIPixelCoord_UINr[uinumber].z == 11){uiDetected2.y = 0;}
				if (uiDetected.z == 0 && UIPixelCoord_UINr[uinumber].z == 12){uiDetected2.z = 0;}
				if (uiDetected2.x == 0){uicolors.r = 1;}
				if (uiDetected2.y == 0){uicolors.g = 1;}
				if (uiDetected2.z == 0){uicolors.b = 1;}
			#endif
			if (uinumber < PIXELNUMBER - 1){
				if (UIPixelCoord_UINr[uinumber].z == UIPixelCoord_UINr[uinumber + 1].z){i -= 1;};
			}
			if (i == 3) {return float4(uicolors, 1);};
			uinumber += 1;
		}
		return float4(uicolors, 1);
	}
#endif

#if (UIDM_MASK_COUNT > 4)
	float4 PS_UIDetect5(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
	{
		float3 pixelColor, uiPixelColor, diff;
		float2 pixelCoord;
		int uinumber;
		
		#if (UIDM_EVERYPIXEL == 0)
			float3 uiDetected2 = 0;
			float3 uicolors = 1;
			float3 uiDetected = 0;
		#else
			float3 uiDetected2 = 1;
			float3 uicolors = 0;
			float3 uiDetected = 1;
		#endif
		
		for (int i=0; i < PIXELNUMBER; i++){
			if (UIPixelCoord_UINr[i].z == 13){uinumber = i; break;}
		}
	
		for (int i=0; i < 3; i++){
			pixelCoord = UIPixelCoord_UINr[uinumber].xy * BUFFER_PIXEL_SIZE;
			pixelColor = round(tex2Dlod(BackBuffer, float4(pixelCoord, 0, 0)).rgb * 255);
			uiPixelColor = UIPixelRGB[uinumber].rgb;
			diff = abs(pixelColor - uiPixelColor);
			#if (UIDM_EVERYPIXEL == 0)
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 13) uiDetected.x = 1;
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 14) uiDetected.y = 1;	
				if (diff.r < toleranceR && diff.g < toleranceG && diff.b < toleranceB && UIPixelCoord_UINr[uinumber].z == 15) uiDetected.z = 1;
				if (uiDetected.x == 1){uiDetected2.x = 1;}
				if (uiDetected.y == 1){uiDetected2.y = 1;}
				if (uiDetected.z == 1){uiDetected2.z = 1;}
				if (uiDetected2.x == 1){uicolors.r = 0;}
				if (uiDetected2.y == 1){uicolors.g = 0;}
				if (uiDetected2.z == 1){uicolors.b = 0;}
			#else
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 13) uiDetected.x = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 14) uiDetected.y = 0;
				if (diff.r > toleranceR && diff.g > toleranceG && diff.b > toleranceB && UIPixelCoord_UINr[uinumber].z == 15) uiDetected.z = 0;
				if (uiDetected.x == 0 && UIPixelCoord_UINr[uinumber].z == 13){uiDetected2.x = 0;}
				if (uiDetected.y == 0 && UIPixelCoord_UINr[uinumber].z == 14){uiDetected2.y = 0;}
				if (uiDetected.z == 0 && UIPixelCoord_UINr[uinumber].z == 15){uiDetected2.z = 0;}
				if (uiDetected2.x == 0){uicolors.r = 1;}
				if (uiDetected2.y == 0){uicolors.g = 1;}
				if (uiDetected2.z == 0){uicolors.b = 1;}
			#endif
			if (uinumber < PIXELNUMBER - 1){
				if (UIPixelCoord_UINr[uinumber].z == UIPixelCoord_UINr[uinumber + 1].z){i -= 1;};
			}
			if (i == 3) {return float4(uicolors, 1);};
			uinumber += 1;
		}
		return float4(uicolors, 1);
	}
#endif

float4 PS_StoreColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
    return tex2D(BackBuffer, texcoord);
}

float4 PS_RestoreColor(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if (UIDM_INVERT == 0)
		float3 colorOrig = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 color = tex2D(BackBuffer, texcoord).rgb;
	#else
		float3 color = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
	#endif
	float3 uiMask = tex2D(UIDetectMaskMulti, texcoord).rgb;
	float3 mask;
	float3 ui = tex2D(UIDetectMulti, float2(0,0)).rgb;
	if (ui.r == 0)	{mask = uiMask.r;	color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)	{mask = uiMask.g;	color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)	{mask = uiMask.b;	color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}

#if (UIDM_MASK_COUNT > 1)
float4 PS_RestoreColor2(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if (UIDM_INVERT == 0)
		float3 colorOrig = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 color = tex2D(BackBuffer, texcoord).rgb;
	#else
		float3 color = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
	#endif
	float3 uiMask = tex2D(UIDetectMaskMulti2, texcoord).rgb;
	float3 mask;
	float3 ui = tex2D(UIDetectMulti2, float2(0,0)).rgb;
	if (ui.r == 0)	{mask = uiMask.r;	color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)	{mask = uiMask.g;	color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)	{mask = uiMask.b;	color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif

#if (UIDM_MASK_COUNT > 2)
float4 PS_RestoreColor3(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if (UIDM_INVERT == 0)
		float3 colorOrig = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 color = tex2D(BackBuffer, texcoord).rgb;
	#else
		float3 color = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
	#endif
	float3 uiMask = tex2D(UIDetectMaskMulti3, texcoord).rgb;
	float3 mask;
	float3 ui = tex2D(UIDetectMulti3, float2(0,0)).rgb;
	if (ui.r == 0)	{mask = uiMask.r;	color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)	{mask = uiMask.g;	color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)	{mask = uiMask.b;	color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif

#if (UIDM_MASK_COUNT > 3)
float4 PS_RestoreColor4(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if (UIDM_INVERT == 0)
		float3 colorOrig = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 color = tex2D(BackBuffer, texcoord).rgb;
	#else
		float3 color = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
	#endif
	float3 uiMask = tex2D(UIDetectMaskMulti4, texcoord).rgb;
	float3 mask;
	float3 ui = tex2D(UIDetectMulti4, float2(0,0)).rgb;
	if (ui.r == 0)	{mask = uiMask.r;	color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)	{mask = uiMask.g;	color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)	{mask = uiMask.b;	color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif

#if (UIDM_MASK_COUNT > 4)
float4 PS_RestoreColor5(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	#if (UIDM_INVERT == 0)
		float3 colorOrig = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 color = tex2D(BackBuffer, texcoord).rgb;
	#else
		float3 color = tex2D(ColorBeforeMulti, texcoord).rgb;
		float3 colorOrig = tex2D(BackBuffer, texcoord).rgb;
	#endif
	float3 uiMask = tex2D(UIDetectMaskMulti5, texcoord).rgb;
	float3 mask;
	float3 ui = tex2D(UIDetectMulti5, float2(0,0)).rgb;
	if (ui.r == 0)	{mask = uiMask.r;	color = lerp(colorOrig, color, mask);}
	if (ui.g == 0)	{mask = uiMask.g;	color = lerp(colorOrig, color, mask);}
	if (ui.b == 0)	{mask = uiMask.b;	color = lerp(colorOrig, color, mask);}
	return float4(color, 1.0);
}
#endif



//techniques
technique UIDetectMulti
{	
	pass {
		VertexShader = PostProcessVS;
		PixelShader = PS_UIDetect;
		RenderTarget = texUIDetectMulti;
	}
	
	#if (UIDM_MASK_COUNT > 1)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_UIDetect2;
			RenderTarget = texUIDetectMulti2;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 2)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_UIDetect3;
			RenderTarget = texUIDetectMulti3;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 3)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_UIDetect4;
			RenderTarget = texUIDetectMulti4;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 4)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_UIDetect5;
			RenderTarget = texUIDetectMulti5;
		}
	#endif
	
	#if (UIDM_DIAGNOSTICS == 1)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = State_Pixel_Color;
			RenderTarget = textextcolor;
		}
		pass {
			VertexShader = PostProcessVS;
			PixelShader = Fontinvert;
			RenderTarget = textextcolor2;
		}
		pass {
			VertexShader = PostProcessVS;
			PixelShader = FontTransparancy;
		}
		pass {
			VertexShader = PostProcessVS;
			PixelShader = Crosshair;
		}
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_StoreColor;
			RenderTarget = texColorOrigMulti;
		}
	#endif
}

technique UIDetectMulti_Before {
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_StoreColor;
        RenderTarget = texColorBeforeMulti;
    }
}

technique UIDetectMulti_After
{
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_RestoreColor;
    }
	
	#if (UIDM_MASK_COUNT > 1)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_RestoreColor2;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 2)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_RestoreColor3;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 3)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_RestoreColor4;
		}
	#endif
	
	#if (UIDM_MASK_COUNT > 4)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_RestoreColor5;
		}
	#endif
	
	#if (UIDM_DIAGNOSTICS == 1)
		pass {
			VertexShader = PostProcessVS;
			PixelShader = PS_ShowOrigColor;
		}
	#endif
}
