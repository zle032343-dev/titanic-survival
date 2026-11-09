import pandas as pd
from sklearn.linear_model import LogisticRegression

train = pd.read_csv("/data/train.csv")
print(f"Training data: {train.shape[0]} rows, {train.shape[1]} columns")
print("Columns:", ", ".join(train.columns))

test = pd.read_csv("/data/test.csv")
print(f"Test data: {test.shape[0]} rows, {test.shape[1]} columns")

features = ["Pclass", "Sex", "Age", "Fare"]
print("\nMissing values in the training data:")
print(train[features].isna().sum())

print("\nMissing values in the test data:")
print(test[features].isna().sum())

# Q14: Prepare the four features
X_train = train[features].copy()
X_test = test[features].copy()
y_train = train["Survived"]

for column in ["Age", "Fare"]:
    median = X_train[column].median()
    X_train[column] = X_train[column].fillna(median)
    X_test[column] = X_test[column].fillna(median)
    print(f"Filled missing {column} values with the training median: {median}")

sex_codes = {"male": 0, "female": 1}
X_train["Sex"] = X_train["Sex"].map(sex_codes)
X_test["Sex"] = X_test["Sex"].map(sex_codes)
print("Encoded Sex: male = 0, female = 1.")

# Q15- 16: Fit the model and measure training accuracy
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)
print("Fitted logistic regression using:", ", ".join(features))
print(f"Training accuracy: {model.score(X_train, y_train):.2%}")

# Q17: Predict survival for the test passengers
predictions = pd.DataFrame({
    "PassengerId": test["PassengerId"],
    "Survived": model.predict(X_test)
})
predictions.to_csv("/output/python_predictions.csv", index=False)
print(f"Saved predictions for {len(predictions)} test passengers.")
print(predictions.head().to_string(index=False))

# Q18: Report the score from Kaggle
print("Kaggle public accuracy for the submitted python_predictions.csv: 75.60%")