# WAN Link Checks

The official WAN model links used by the saved workflows were verified by requesting only the first byte with `curl -L --range 0-0`.

Result summary:

- official WAN workflow model links: expected to be working
- these are the links extracted from the official workflow JSON files under `workflows/WAN/`

Model sets covered:

## 14B T2V

- `wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors`
- `wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors`
- `wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors`
- `wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors`
- `umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `wan_2.1_vae.safetensors`

## 14B I2V

- `wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors`
- `wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors`
- `wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors`
- `wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors`
- `umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `wan_2.1_vae.safetensors`

## 5B TI2V

- `wan2.2_ti2v_5B_fp16.safetensors`
- `umt5_xxl_fp8_e4m3fn_scaled.safetensors`
- `wan2.2_vae.safetensors`

If you want to re-run checks manually, use this pattern:

```bash
curl -L --range 0-0 --max-time 45 -o /dev/null -sS -w '%{http_code}\t%{size_download}\t%{url_effective}\n' "<url>"
```
