# Digital Humanities Pipeline

Currently only available on mac, but trivially generalizable to linux (just replace `pbcopy` with `xclip --selection clipboard` or whatever you use to copy stuff to your clipboard on a linux box). 

## Getting started

In order to run the scripts in your terminal, you will need to install `homebrew` (https://brew.sh/) `bash 5` and `tesseract`

After you have installed homebrew, run the following commands: 

```
brew install bash
brew install tesseract
```

Set the environment variable `OLDNEWS_OCR_FOLDER` to the folder with screenshots of your newspaper article. Both .png and .jpeg should work. 

Run the file `tesseract_ocr.sh` and write the result to a temporary file. 

example:

```sh
./tesseract_ocr.sh
```

To view the result, you can `cat` it to the terminal:

```sh
cat /tmp/oldnews_ocr.I9wHV6
```

Most likely this will contain a bunch of mistakes, but open-access AI tools are very good at understanding the context and fixing them. The following command will copy both the instructions.txt file and the temporary file to your clipboard, so that you can then paste it into claude, chatgpt, gemini, deepseek, or whatever Open-Access LLM that hasn't rate limited you :) 

```sh
cat /tmp/oldnews_ocr.I9wHV6 llm_instructions.md | pbcopy
```


That's it! You can now double check that the output makes sense! If it does, you can upload it to our [article repository](https://github.com/victorelgersma/oldnews-article-repo)

