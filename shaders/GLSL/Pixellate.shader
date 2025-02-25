<?xml version="1.0" encoding="UTF-8"?>
<!--
    Copyright (c) 2011, 2012 Fes

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
    SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
    IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

    (Fes gave their permission to have this shader distributed under this
    licence in this forum post:

        http://board.byuu.org/styles/serenity/imageset/icon_topic_latest.gif

    )

-->
<shader language="GLSL">
    <vertex><![CDATA[
        void main()
        {
                gl_Position    = ftransform();
                gl_TexCoord[0] = gl_MultiTexCoord0;
        }
    ]]></vertex>

    <fragment filter="nearest"><![CDATA[
        uniform sampler2D rubyTexture;
        uniform vec2      rubyTextureSize;

        #define round(x) floor( (x) + 0.5 )

        void main()
        {
                vec2 texelSize = 1.0 / rubyTextureSize;
                vec2 texCoord = gl_TexCoord[0].xy;

                vec2 range = vec2(abs(dFdx(texCoord.x)), abs(dFdy(texCoord.y)));
                range = range / 2.0 * 0.999;

                float left   = texCoord.x - range.x;
                float top    = texCoord.y + range.y;
                float right  = texCoord.x + range.x;
                float bottom = texCoord.y - range.y;

                vec4 topLeftColor     = texture2D(rubyTexture, vec2(left, top));
                vec4 bottomRightColor = texture2D(rubyTexture, vec2(right, bottom));
                vec4 bottomLeftColor  = texture2D(rubyTexture, vec2(left, bottom));
                vec4 topRightColor    = texture2D(rubyTexture, vec2(right, top));

                vec2 border = clamp(
                        round(texCoord / texelSize) * texelSize,
                        vec2(left, bottom),
                        vec2(right, top)
                    );

                float totalArea = 4.0 * range.x * range.y;

                vec4 averageColor;
                averageColor  = ((border.x - left)  * (top - border.y)    / totalArea) * topLeftColor;
                averageColor += ((right - border.x) * (border.y - bottom) / totalArea) * bottomRightColor;
                averageColor += ((border.x - left)  * (border.y - bottom) / totalArea) * bottomLeftColor;
                averageColor += ((right - border.x) * (top - border.y)    / totalArea) * topRightColor;

                gl_FragColor = averageColor;
        }
    ]]></fragment>
</shader>
