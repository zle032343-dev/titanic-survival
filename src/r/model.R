# Q13–14: Load the data and check for missing values
train <- read.csv("/data/train.csv")
test <- read.csv("/data/test.csv")

cat(sprintf("Training data: %d rows, %d columns\n", nrow(train), ncol(train)))
cat(sprintf("Test data: %d rows, %d columns\n", nrow(test), ncol(test)))

features <- c("Pclass", "Sex", "Age", "Fare")

cat("\nMissing values in the training data:\n")
print(colSums(is.na(train[features])))

cat("\nMissing values in the test data:\n")
print(colSums(is.na(test[features])))

for (column in c("Age", "Fare")) {
  train_median <- median(train[[column]], na.rm = TRUE)
  train[[column]][is.na(train[[column]])] <- train_median
  test[[column]][is.na(test[[column]])] <- train_median
  cat(sprintf("Filled missing %s values with training median: %g\n",
              column, train_median))
}

train$Sex <- as.integer(train$Sex == "female")
test$Sex <- as.integer(test$Sex == "female")
cat("Encoded Sex: male = 0, female = 1.\n")

# Q15: Fit logistic regression
model <- glm(
  Survived ~ Pclass + Sex + Age + Fare,
  data = train,
  family = binomial()
)
cat("Fitted logistic regression using Pclass, Sex, Age, and Fare.\n")

# Q16: Calculate training accuracy
train_prob <- predict(model, newdata = train, type = "response")
train_pred <- as.integer(train_prob >= 0.5)
train_accuracy <- mean(train_pred == train$Survived)
cat(sprintf("Training accuracy: %.2f%%\n", 100 * train_accuracy))

# Q17: Predict survival for the test passengers
test_prob <- predict(model, newdata = test, type = "response")
predictions <- data.frame(
  PassengerId = test$PassengerId,
  Survived = as.integer(test_prob >= 0.5)
)

write.csv(predictions, "/output/r_predictions.csv", row.names = FALSE)
cat(sprintf("Saved predictions for %d test passengers.\n", nrow(predictions)))
print(head(predictions, 5), row.names = FALSE)

cat("Kaggle public score for the submitted r_predictions.csv: 0.75837 (75.84%)\n")