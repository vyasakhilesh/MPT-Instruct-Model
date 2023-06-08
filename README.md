# How to run/deploy MPT-Instruct model

Commnds to run/deploy model using Docker
```bash
$ docker build --tag 'mpt_img'
$ docker run -v model:/model -p 12345:12345 --gpus all -d --name mpt_img
```
Commands to run MPT model using Singularity
```bash
$ singularity build mpt.sif mpt.def

$ sbatch --mem 32G -w devbox4 -J MPT-model --gres=gpu:a5000:1 singularity.sh exec --bind tmp:/tmp,model:/model mpt.sif sh start.sh
```

