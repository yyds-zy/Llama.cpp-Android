gross_pruned_ratio=0.03
pruning_ratio=0.1
begin_pruned_layer=4
end_pruned_layer=30
base_model=/data2/xmwang/raw_model/phi-2
work_dir=/data2/ericao
file_name=phi_2_${gross_pruned_ratio}_${begin_pruned_layer}-${end_pruned_layer}

# # 剪枝
# echo ----------------------------- pruning --------------------------
# cd ${work_dir}/LLM-Pruner
# CUDA_VISIBLE_DEVICES=2 python phi2.py \
#       --base_model ${base_model} \
#       --pruning_ratio $pruning_ratio \
#       --block_wise \
#       --block_mlp_layer_start $begin_pruned_layer --block_mlp_layer_end $end_pruned_layer \
#       --block_attention_layer_start $begin_pruned_layer --block_attention_layer_end $end_pruned_layer \
#       --pruner_type taylor \
#       --device cpu \
#       --eval_device cuda \
#       --save_ckpt_log_name ${file_name} \
#       --save_model

# # 将 bin 转换成 HuggingFace
# echo ----------------------------- converting bin to HuggingFace --------------------------
# cd ${work_dir}/convert
# CUDA_VISIBLE_DEVICES=2 python convert_phi2.py --phi_dir ${base_model} \
#     --save_dir ${work_dir}/convert/${file_name} \
#     --pruned_dir ${work_dir}/LLM-Pruner/prune_log/${file_name}/pytorch_model.bin \
#     --begin_pruned_layer $begin_pruned_layer \
#     --end_pruned_layer $end_pruned_layer

# 将 HuggingFace 转换为 .gguf
echo ----------------------------- converting HuggingFace to gguf --------------------------
cd ${work_dir}/llama.cpp
CUDA_VISIBLE_DEVICES=2 python convert_hf_to_gguf.py \
${work_dir}/convert/${file_name} \
--outtype f16 \
--outfile ${work_dir}/deployed-models/${file_name}.gguf

# 推理
echo ----------------------------- reasoning about gguf --------------------------
cd ${work_dir}/llama.cpp
# make clean
# make -j32
# make -j32 GGML_CUDA=1
./llama-cli -m ${work_dir}/deployed-models/${file_name}.gguf \
    -n 128 \
    -ngl 9999 \
    --prompt "Complete the following python code:\nfrom typing import List\n\n\ndef has_close_elements(numbers: List[float], threshold: float) -> bool:\n    \"\"\" Check if in given list of numbers, are any two numbers closer to each other than\n    given threshold.\n    >>> has_close_elements([1.0, 2.0, 3.0], 0.5)\n    False\n    >>> has_close_elements([1.0, 2.8, 3.0, 4.0, 5.0, 2.0], 0.3)\n    True\n    \"\"\"\n\n"
# --prompt "Where is the capital city of China?"