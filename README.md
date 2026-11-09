# Titanic Survival Prediction

This project uses logistic regression to predict whether Titanic passengers survived based on their passenger class, sex, age, and fare. The Python and R versions use the same predictors and run in separate Docker containers.

Each script checks for missing values and fills missing ages and fares using medians from the training set. It then fits the model, prints the training accuracy, and saves predictions for the test passengers.

Step 2 explains how to download the dataset from Kaggle and where to place the files.

## Repository structure

```text
titanic-survival/
├── .github/
│   └── CODEOWNERS
├── .gitignore
├── README.md
└── src/
    ├── data/                 # Create locally for the Kaggle CSV files
    │   └── predictions/      # Output from the Python and R models
    ├── python/
    │   ├── Dockerfile
    │   ├── requirements.txt
    │   └── model.py
    └── r/
        ├── Dockerfile
        ├── install_packages.R
        └── model.R
```

## Prerequisites

| Tool | Used for | Install |
|---|---|---|
| Git | cloning the repository | https://git-scm.com/downloads |
| Docker Desktop | building and running the containers | https://docs.docker.com/get-docker/ |
| Free Kaggle account | downloading the data | https://www.kaggle.com |

You do not need Python or R installed; everything runs inside Docker. 

## 1. Clone the repository

Install Git and Docker Desktop. Start Docker Desktop before running the commands below.

Open PowerShell on Windows or Terminal on macOS and run:

```powershell

git clone https://github.com/zle032343-dev/titanic-survival.git

cd titanic-survival

```

Run the rest of the commands from the `titanic-survival` folder.

## 2. Download the data

1. Go to [Kaggle](https://www.kaggle.com/competitions/titanic/data) and sign in.
2. Click **Join Competition** and accept the rules (Kaggle blocks the download until you do).
3. Click **Download All**. This saves `titanic.zip`, usually in your Downloads folder.
4. Create the data folders and unzip the file into `src/data`.

Windows PowerShell:

```powershell
mkdir src\data\predictions
Expand-Archive -Path "$HOME\Downloads\titanic.zip" -DestinationPath src\data -Force
```

macOS / Linux:

```bash
mkdir -p src/data/predictions
unzip ~/Downloads/titanic.zip -d src/data
```

When you are done, these should exist (`gender_submission.csv` is not used):

```text
src/data/train.csv
src/data/test.csv
src/data/predictions/        (empty folder; the models write their output here)
```

## 3. Run the Python model

Build the Python image:

```powershell

docker build -t titanic-python ./src/python

```

After the build finishes, run the container:

```powershell

docker run --rm --mount "type=bind,source=$PWD/src/data,target=/data,readonly" --mount "type=bind,source=$PWD/src/data/predictions,target=/output" titanic-python

```

The script prints the training accuracy and saves predictions for all 418 test passengers to `src/data/predictions/python_predictions.csv`.

## 4. Run the R model

Build the R image:

```powershell

docker build -t titanic-r ./src/r

```

After the build finishes, run the container:

```powershell

docker run --rm --mount "type=bind,source=$PWD/src/data,target=/data,readonly" --mount "type=bind,source=$PWD/src/data/predictions,target=/output" titanic-r

```

The script prints the training accuracy and saves predictions for all 418 test passengers to `src/data/predictions/r_predictions.csv`.

## 5. Model results

The Python model had a training accuracy of 79.91% and a Kaggle public score of 0.75598.

The R model had a training accuracy of 80.02% and a Kaggle public score of 0.75837.

Since `test.csv` does not include the actual survival outcomes, the public scores come from submitting each model’s predictions to Kaggle.

