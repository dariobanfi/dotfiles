#language slang 2026
// Soft focus indicator for splits.
// Unfocused splits sink toward a darker shade, with a soft gradient around the
// focused split instead of a hard edge. In FADE_IN mode the focused split starts
// at the unfocused look and fades up, driven by animation_progress (0 -> 1).

import kitty_custom_shader_types;

// Fraction of the original color kept in unfocused splits (1.0 = no effect).
static const float INACTIVE_KEEP = 0.5;
// Shade unfocused splits blend toward, in linear RGB. Default: Catppuccin crust #11111b.
static const float3 INACTIVE_COLOR = float3(0.00561, 0.00561, 0.01096);
// Width of the gradient around the focused split, as a multiple of the window padding.
static const float EDGE_SOFTNESS = 1.0;
// false: dim everything outside the focused split. true: fade the focused split in.
static const bool FADE_IN = false;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    // Leave the tab bar alone.
    float4 area = d.central_area;
    if (any(t.pos < area.xy) || any(t.pos > area.xy + area.zw)) return color;
    float4 g = d.active_window_geometry;
    if (g.z <= 0.0 || g.w <= 0.0) return color;
    g.xy -= d.active_window_padding.xy;
    g.zw += d.active_window_padding.xy + d.active_window_padding.zw;

    // Work in pixels so the gradient is equally wide horizontally and vertically.
    float2 px = float2(d.viewport_size_pixels);
    float2 win_min = g.xy * px, win_max = (g.xy + g.zw) * px;
    float4 pad = d.active_window_padding * float4(px, px);
    float soft = max(EDGE_SOFTNESS * min(min(pad.x, pad.y), min(pad.z, pad.w)), 1.0);

    // Only one split visible: nothing to tell apart.
    float2 slack = (area.zw - g.zw) * px;
    if (max(slack.x, slack.y) < soft) return color;

    float2 p = t.pos * px;
    float outside = length(max(max(win_min - p, p - win_max), 0.0));
    float amount = smoothstep(0.0, soft, outside);
    if (FADE_IN) amount = (1.0 - amount) * (1.0 - t.animation_progress);
    return float4(lerp(color.rgb, INACTIVE_COLOR, amount * (1.0 - INACTIVE_KEEP)), color.a);
}
