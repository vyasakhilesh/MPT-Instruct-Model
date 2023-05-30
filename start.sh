#!/bin/sh

MODEL_DIR="model"

# Check if the model folder exists and contains files
if [ ! -d "$MODEL_DIR" ] || [ -z "$(ls -A "$MODEL_DIR")" ]; then
	# Download the model
	git lfs install
	git clone https://huggingface.co/mosaicml/mpt-7b-instruct "$MODEL_DIR"
fi

# Launch the controller
# python3 -m fastchat.serve.controller \
# 	 --host 0.0.0.0 --port 21001 \
# 	 > /tmp/fastChat_CONTROLLER.out \
#         2> /tmp/fastChat_CONTROLLER.err &

python3 -m fastchat.serve.controller \
	 --host 0.0.0.0 --port 21001 \
	 > /tmp/fastChat_CONTROLLER.out \
        2> /tmp/fastChat_CONTROLLER.err &

# Add a delay to allow the controller to boot up
sleep 2


# Launch the model worker
python3 /app/model_worker.py \
      --host 0.0.0.0 --port 39805 \
      --controller-address http://0.0.0.0:21001 \
      --worker-address http://0.0.0.0:39805 \
      --model-path "/$MODEL_DIR" \
      --model-name 'MPT-7B-Instruct' &

# Add a delay to allow the model worker to finish loading
sleep 50

# Restful API
python3 -m fastchat.serve.openai_api_server --host 0.0.0.0 --port 12346 &


echo "Start Web UI"

# Run the Gradio web server
python3 /app/gradio_web_server.py \
	--port 12345 \
	--controller-url http://0.0.0.0:21001 

# Keep script running
tail -f /dev/null
