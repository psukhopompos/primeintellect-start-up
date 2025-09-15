# primeintellect-start-up

## 0th step: You need to be able to connect to the ssh
If you don't know how to do this, or if it's a bit like a gray area, learn this first. Become comfortable with connecting.
For ease, use the provided "system keys" from primeintellect. https://app.primeintellect.ai/dashboard/tokens
Download the private key and put it in your workspace. Then, go talk to your preferred AI to learn how to connect to the instance freely

## 1st step: Choose your name and model

Go to provision_fortress_v3.sh file 
Edit lines 19, 20, 27, 80 and 81 to choose your project's name.
Edit lines 54 and 55 to download the model you want

## 2nd step: Choose the model you want to serve on sglang

Based on the name and model you chose on the 1st step,
Go to launch_sglang_server.sh file
Edit line 7 with your model
Edit line 8 and 17 with your name
???
Profit

## 3rd and final step:

In the code you are building to use DSPy, use some variation of the following when configuring your LM:

# --- 1. Configure DSPy to connect to our SGLang Server ---
try:
    llm = dspy.LM(
        model="openai/sequelbox/Qwen3-14B-DAG-Reasoning", # Your downloaded model goes here! Note that it goes with openai at the beginning because it's an OpenAI Compatible endpoint!
        api_base="http://localhost:7501/v1",
        api_key="local",
        model_type="chat",
        # Unchain the model: Increase max_tokens
        max_tokens=12000
    )
    dspy.configure(lm=llm)
    print("✓ DSPy configured to connect to local SGLang server (High Performance Mode).")
except Exception as e:
    print(f"❌ CRITICAL: Failed to configure DSPy: {e}")
    exit(1)
