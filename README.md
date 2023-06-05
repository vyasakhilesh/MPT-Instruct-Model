# How to run MPT model
Commands to run MPT model using singularity
```bash
$ singularity build mpt.sif mpt.def

$ sbatch --mem 32G -w devbox4 -J MPT-model --gres=gpu:a5000:1 singularity.sh exec --bind tmp:/tmp,model:/model mpt.sif sh start.sh
``` 