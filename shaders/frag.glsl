#version 300 es
precision mediump float;

in vec3 fNormal, fView;
in vec3 vWorldPos;
in vec2 fTexCoord;

uniform vec3 eyePos;
uniform sampler2D texImage;

uniform float matSh;       
uniform vec3 matSpec, matAmbi, matEmit;     

uniform vec3 srcDiff, srcSpec, srcAmbi;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 texColor = texture(texImage, fTexCoord);

    // matEmit으로 태양을 판정 (emit.r이 0.9보다 크면 태양; 빛 연산에서 제외)
    if (matEmit.r > 0.9) {
        fragColor = texColor; 
        return; 
    }

    vec3 normal = normalize(fNormal);

    vec3 lightPos = vec3(0.0, 0.0, 0.0); 
    
    vec3 light = normalize(lightPos - vWorldPos);
    vec3 view = normalize(fView);

    // Diffuse
    vec3 matDiff = texColor.rgb;
    vec3 diff = max(dot(normal, light), 0.0) * srcDiff * matDiff;

    // Specular
    vec3 halfv = normalize(light + view);
    vec3 spec = pow(max(dot(normal, halfv), 0.0), matSh) * srcSpec * matSpec;

    // Ambient
    vec3 ambi = srcAmbi * matAmbi * texColor.rgb;

    fragColor = vec4(diff + spec + ambi + matEmit, 1.0);
}