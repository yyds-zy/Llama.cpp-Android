gross_pruned_ratio=0.5
begin_pruned_layer=4
end_pruned_layer=30
work_dir=/data/ericao
model_name=llama_3.1_${gross_pruned_ratio}_${begin_pruned_layer}-${end_pruned_layer}
# model_name=llama_3.1
# base_model=${work_dir}/convert/${model_name}
merged_path=/data2/xyy/fine-tuning/LLaMA-Factory/saves/${model_name}/lora/merged
# merged_path=/data2/xmwang/raw_model/llama3.1_8B
# sft_path=/data2/xyy/fine-tuning/LLaMA-Factory/saves/${model_name}/lora/sft
file_name=${model_name}_lora

gguf_dir=${work_dir}/deployed-models/${file_name}.gguf
code_dir=/data2/ericao/llama.cpp

# # 将 HuggingFace 转换为 .gguf
# echo ----------------------------- converting HuggingFace to gguf --------------------------
# cd ${code_dir}
# CUDA_VISIBLE_DEVICES=2 python convert_hf_to_gguf.py \
# ${merged_path} \
# --outtype bf16 \
# --outfile ${gguf_dir}
# # --base ${base_model} \

# du -sh ${gguf_dir}

# 推理
echo ----------------------------- reasoning about gguf --------------------------
cd ${code_dir}/llama.cpp
# make clean
# make -j32
# make -j32 GGML_CUDA=1
./llama-cli -m ${gguf_dir} \
    -n 128 \
    -ngl 9999 \
    --prompt "中国的首都是哪里？"
    # --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"

# ./llama-bench -m ${work_dir}/deployed-models/${file_name}.gguf -p 0 -n 128,256,512
