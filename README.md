# Titanic Survival Prediction



This project uses logistic regression to predict whether Titanic passengers survived based on their passenger class, sex, age, and fare. The Python and R versions use the same predictors and run in separate Docker containers.



## 1. Clone the repository



Install Git and Docker Desktop. Start Docker Desktop before running the commands below.



Open Windows PowerShell and run:



```powershell

git clone https://github.com/zle032343-dev/titanic-survival.git

cd titanic-survival

```



Run the rest of the commands from the `titanic-survival` folder.



## 2. Download the data



Download the Titanic data from [Kaggle](https://www.kaggle.com/competitions/titanic/data) and extract the ZIP file.

Create a `data` folder inside `src`, then create a `predictions` folder inside `data`. Copy `train.csv` and `test.csv` into `src/data/`. 

The file paths should be:



```text

src/data/train.csv

src/data/test.csv

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



The script prints the training accuracy and saves predictions for all 418 test passengers to `src/data/predictions/python\_predictions.csv`.



## 4. Run the R model



Build the R image:



```powershell

docker build -t titanic-r ./src/r

```



After the build finishes, run the container:



```powershell

docker run --rm --mount "type=bind,source=$PWD/src/data,target=/data,readonly" --mount "type=bind,source=$PWD/src/data/predictions,target=/output" titanic-r

```



The script prints the training accuracy and saves predictions for all 418 test passengers to `src/data/predictions/r\_predictions.csv`.



## 5. Model results



The Python model had a training accuracy of 79.91% and a Kaggle public score of 0.75598.



The R model had a training accuracy of 80.02% and a Kaggle public score of 0.75837.



Since `test.csv` does not include the actual survival outcomes, the public scores come from submitting each model’s predictions to Kaggle.

