#include "ReShade.fxh"

//effect parameters
uniform float2 fAC_SourceTopLeft <
    ui_label = "Source coordinates";
    ui_tooltip = "Top left x and y coordinate of the source area.";
    ui_type = "drag";
    ui_min = 0.0;
    ui_max = BUFFER_WIDTH;
    ui_step = 1.0;
> = float2(100, 100);

uniform float2 fAC_DestTopLeft <
    ui_label = "Destination coordinates";
    ui_tooltip = "Top left x and y coordinate of the destination area.";   
    ui_type = "drag";
    ui_min = 0.0;
    ui_max = BUFFER_WIDTH;
    ui_step = 1.0;    
> = float2(1300, 700);

uniform float2 fAC_Size <
    ui_label = "Area dimensions";
    ui_tooltip = "Size of the area in x and y dimension.";     
    ui_type = "drag";
    ui_min = 0.0;
    ui_max = BUFFER_WIDTH;
    ui_step = 1.0;    
> = float2(200, 200);

uniform bool bAC_EnableSourceColorFill <
      ui_label = "Enable source area color fill.";
> = false;

uniform float3 fAC_FillColor <
    ui_label = "Source area fill color.";
    ui_type = "color";
> = float3(0.0, 0.0, 0.0);

//pixel shaders
float4 PS_AreaCopy(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target {

    float4 color = tex2Dfetch(ReShade::BackBuffer, pos.xy);

    float2 sourceTopLeft = fAC_SourceTopLeft;
    float2 sourceBottomRight = sourceTopLeft + fAC_Size;
    float2 destTopLeft = fAC_DestTopLeft;
    float2 destBottomRight = destTopLeft + fAC_Size; 
    float2 dist = destTopLeft - sourceTopLeft;
    
    if (pos.x > destTopLeft.x && pos.y > destTopLeft.y && pos.x < destBottomRight.x && pos.y < destBottomRight.y) {
        color = tex2Dfetch(ReShade::BackBuffer, pos.xy - dist);
    }
    
    if (bAC_EnableSourceColorFill) {
        if (pos.x > sourceTopLeft.x && pos.y > sourceTopLeft.y && pos.x < sourceBottomRight.x && pos.y < sourceBottomRight.y) {
            color.xyz = fAC_FillColor;
        }
    }
    
    return color;
}

//techniques
technique AreaCopy {
    pass {
        VertexShader = PostProcessVS;
        PixelShader = PS_AreaCopy;
    }
}
