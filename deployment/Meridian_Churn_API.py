
from flask import Flask, request, jsonify
import pandas as pd
import joblib

app = Flask(__name__)

# Load the saved churn prediction model
model_path = "/content/drive/MyDrive/Meridian_Final_Churn_Model.pkl"
loaded_model = joblib.load(model_path)

# Features required by the model
required_features = [
    "recency",
    "frequency",
    "monetary",
    "age_at_cutoff",
    "ticket_count",
    "avg_resolution_hours",
    "avg_satisfaction",
    "gender",
    "membership_tier",
    "preferred_channel",
    "state",
    "referral_source",
    "marketing_opt_in"
]

numeric_features = [
    "recency",
    "frequency",
    "monetary",
    "age_at_cutoff",
    "ticket_count",
    "avg_resolution_hours",
    "avg_satisfaction"
]

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()

        if not isinstance(data, dict):
            return jsonify({
                "error": "Please provide customer data as a JSON object."
            }), 400

        missing_features = [
            feature for feature in required_features
            if feature not in data
        ]

        if missing_features:
            return jsonify({
                "error": "Missing required features",
                "missing_features": missing_features
            }), 400

        for feature in numeric_features:
            value = data[feature]

            if value is not None:
                try:
                    data[feature] = float(value)
                except (ValueError, TypeError):
                    return jsonify({
                        "error": f"Invalid value: {feature} must be a number."
                    }), 400

        customer_data = pd.DataFrame(
            [{feature: data[feature] for feature in required_features}]
        )

        prediction = int(loaded_model.predict(customer_data)[0])
        probabilities = loaded_model.predict_proba(customer_data)[0]

        return jsonify({
            "churn_prediction": prediction,
            "result": "Likely to churn" if prediction == 1 else "Not likely to churn",
            "probability_not_churning": round(float(probabilities[0]), 4),
            "probability_of_churning": round(float(probabilities[1]), 4)
        })

    except Exception:
        return jsonify({
            "error": "Unable to process the prediction request."
        }), 400


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
