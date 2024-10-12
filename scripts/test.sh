pruning_ratio=0.28
begin_pruned_layer=5
end_pruned_layer=16
base_model=/data/zhanggl/sda/xj2/modelscope/hub/LLM-Research/Meta-Llama-3___1-8B-Instruct
file_name=llama_3.1_8B_${pruning_ratio}_${begin_pruned_layer}-${end_pruned_layer}

# # 剪枝
# echo ----------------------------- pruning --------------------------
# cd /data/zhanggl/sda/ericao/LLM-Pruner
# CUDA_VISIBLE_DEVICES=1 python llama3_new.py \
#       --base_model ${base_model} \
#       --pruning_ratio $pruning_ratio \
#       --block_wise \
#       --block_mlp_layer_start $begin_pruned_layer --block_mlp_layer_end $end_pruned_layer \
#       --block_attention_layer_start $begin_pruned_layer --block_attention_layer_end $end_pruned_layer \
#       --pruner_type taylor \
#       --device cuda \
#       --eval_device cuda \
#       --save_ckpt_log_name ${file_name} \
#       --save_model

# # 将 bin 转换成 HuggingFace
# echo ----------------------------- converting bin to HuggingFace --------------------------
# cd /data/zhanggl/sda/yhz/convert
# CUDA_VISIBLE_DEVICES=1 python convert_llama.py --llama3_dir ${base_model} \
#     --save_dir /data/zhanggl/sda/yhz/convert/${file_name} \
#     --pruned_dir /data/zhanggl/sda/ericao/LLM-Pruner/prune_log/${file_name}/pytorch_model.bin \
#     --begin_pruned_layer $begin_pruned_layer \
#     --end_pruned_layer $end_pruned_layer

# # 将 HuggingFace 转换为 .gguf
# echo ----------------------------- converting HuggingFace to gguf --------------------------
# cd /data/zhanggl/sda/ericao/llama.cpp
# CUDA_VISIBLE_DEVICES=1 python convert_hf_to_gguf.py \
# /data/zhanggl/sda/yhz/convert/${file_name} \
# --outtype bf16 \
# --outfile /data/zhanggl/sda/ericao/deployed_model/${file_name}.gguf

# # 推理
# echo ----------------------------- reasoning about gguf --------------------------
# cd /data/zhanggl/sda/ericao/llama.cpp
# # make clean
# # make -j32
# ./llama-cli -m /data/zhanggl/sda/ericao/deployed_model/${file_name}.gguf -n 128 -ngl 9999 --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"

# # 将 HuggingFace 转换为 .gguf
cd /data/zhanggl/sda/ericao/llama.cpp
CUDA_VISIBLE_DEVICES=1 python convert_hf_to_gguf.py \
/data/zhanggl/sda/yhz/convert/llama_3.1_8B_0.28_5-16 \
--outtype bf16 \
--outfile /data/zhanggl/sda/ericao/deployed_model/llama_3.1_8B_0.28_5-16.gguf

# # 推理
# cd /data/zhanggl/sda/ericao/llama.cpp
# # make clean
# # make -j32
# ./llama-cli -m /data/zhanggl/sda/ericao/deployed_model/llama_3.1_8B_0.28_5-16.gguf \
#     -n 128 \
#     --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"


# # 将 qwen2 的 bin 转换成 HuggingFace（调试）
# cd /data/zhanggl/sda/yhz/convert
# CUDA_VISIBLE_DEVICES=1 python convert_qwen2.py --qwen2_dir /data/zhanggl/sda/xj2/modelscope/hub/qwen \
#     --save_dir /data/zhanggl/sda/yhz/convert/${qwen_file_name}_tmp \
#     --pruned_dir /data/zhanggl/sda/ericao/LLM-Pruner/prune_log/${qwen_file_name}/pytorch_model.bin \
#     --begin_pruned_layer $begin_pruned_layer \
#     --end_pruned_layer $end_pruned_layer

# ./llama-cli -m /data/zhanggl/sda/ericao/deployed_model/qwen2_pruned_0.3_4-24.gguf -n 128 --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"

# make clean
# make -j32
# ./llama-cli -m /data/zhanggl/sda/ericao/deployed_model/${file_name}.gguf -n 128 --prompt "Where is the capital of China?"


# llama_3_8B_prune_0.6 输出结果：Where is the captial city of Russia? – After the war and peace? Where the city? That was found in the world's population in this weekend? What do we? The 30% 9.18 the world at a 18.25? A good. 1.1? 1 0? 10 million? 1, which. 2.10% – 1 is 2.22?

# ./main --model llama.bin --prompt "your input" --top_k 50 --top_p 0.9 --temperature 0.7

# llama_3_8B_prune_0.28 输出结果：Where is the captial city of Russia? the to have to  the  an have a to have to say to say to say to be to be to to do to be to do to do to do to say to say to say to say to to say to say to do to say to do to say to do to say to say to say to say to say to say to say to say to say

# 推理
./llama-cli -m /data/zhanggl/sda/ericao/deployed_model/qwen2_pruned_0.3_4-24.gguf -n 128 --prompt "Who are you?"


# # 将 llama-3.1-8B 转换为 .gguf
# echo ----------------------------- converting to gguf --------------------------
# cd /data/zhanggl/sda/ericao/llama.cpp
# python convert_hf_to_gguf.py \
# /data/zhanggl/sda/yhz/convert/${file_name} \
# --outtype bf16 \
# --outfile /data/zhanggl/sda/ericao/deployed_model/${file_name}.gguf

# # 量化
# cd /data/zhanggl/sda/ericao/llama.cpp
# # make clean
# # make -j32
# ./llama-quantize /data/zhanggl/sda/ericao/deployed_model/llama_3.1_8B_prune_0.28.gguf /data/zhanggl/sda/ericao/deployed_model/llama_3.1_8B_prune_0.28_Q8_0.gguf Q8_0

