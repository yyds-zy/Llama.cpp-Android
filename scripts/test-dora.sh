gross_pruned_ratio=0.5
begin_pruned_layer=4
end_pruned_layer=30
work_dir=/data2/ericao
model_name=llama_3.1_${gross_pruned_ratio}_${begin_pruned_layer}-${end_pruned_layer}
base_model=${work_dir}/convert/${model_name}
merged_path=/data2/xyy/fine-tuning/LLaMA-Factory/saves/${model_name}/dora/merged
sft_path=/data2/xyy/fine-tuning/LLaMA-Factory/saves/${model_name}/dora/sft
file_name=${model_name}_dora


# 将 HuggingFace 转换为 .gguf
echo ----------------------------- converting HuggingFace to gguf --------------------------
cd ${work_dir}/llama.cpp
CUDA_VISIBLE_DEVICES=2 python convert_lora_to_gguf.py \
${sft_path} \
--base ${base_model} \
--outtype bf16 \
--outfile ${work_dir}/deployed-models/${file_name}.gguf
#  --base ${base_model} \

du -sh ${work_dir}/deployed-models/${file_name}.gguf

# # 推理
# echo ----------------------------- reasoning about gguf --------------------------
# cd ${work_dir}/llama.cpp
# # make clean
# # make -j32
# # make -j32 GGML_CUDA=1
# ./llama-cli -m ${work_dir}/deployed-models/${file_name}.gguf \
#     -n 128 \
#     -ngl 9999 \
#     --prompt "你好"
#     # --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"

# ./llama-bench -m ${work_dir}/deployed-models/${file_name}.gguf -p 0 -n 128,256,512
