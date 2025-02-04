import torch
from PIL import Image
from scripts.evaluation.inference import load_model_checkpoint
from utils.utils import instantiate_from_config
import numpy as np
import argparse
import os
from omegaconf import OmegaConf


# Load the sketch colorization model
def load_model(checkpoint_path):
    # Load the model and set it to evaluation mode
    config = OmegaConf.load("./configs/inference_512_v1.0.yaml")
    model_config = config.pop("model", OmegaConf.create())
    model_config['params']['unet_config']['params']['use_checkpoint'] = False
    model = instantiate_from_config(model_config)
    model = load_model_checkpoint(model, checkpoint_path)
    model.perframe_ae = False
    # model = model.cuda(1)

    # model = torch.load(checkpoint_path, map_location=torch.device('cpu'))
    model.eval()
    return model


# Define the colorization function
def colorize_sketch(sketch, reference, model):
    # Resize images to the expected input size
    sketch = sketch.resize((256, 256))
    reference = reference.resize((256, 256))

    # Convert images to numpy arrays, then to torch tensors
    sketch_tensor = torch.from_numpy(np.array(sketch)).unsqueeze(0).float()
    reference_tensor = torch.from_numpy(np.array(reference)).unsqueeze(0).float()

    # Run the model inference
    with torch.no_grad():
        output = model(sketch_tensor, reference_tensor)

    # Convert model output to an image
    colorized_image = Image.fromarray(output.squeeze().numpy().astype('uint8'))
    return colorized_image


# Main function with CLI support
def main():
    parser = argparse.ArgumentParser(description="CLI-Based Sketch Colorization with ToonCrafter")
    parser.add_argument('--sketch', type=str, required=True, help="Path to the input sketch image")
    parser.add_argument('--reference', type=str, required=True, help="Path to the reference color image")
    parser.add_argument('--checkpoint', type=str, required=True, help="Path to model checkpoint")
    args = parser.parse_args()

    # Load the model
    model = load_model(args.checkpoint)

    # Load the images
    sketch = Image.open(args.sketch)
    reference = Image.open(args.reference)

    # Colorize the sketch
    colorized_image = colorize_sketch(sketch, reference, model)

    # Save the output
    output_path = os.path.splitext(args.sketch)[0] + "_colorized.png"
    colorized_image.save(output_path)
    print(f"Colorized image saved to {output_path}")


if __name__ == '__main__':
    main()
