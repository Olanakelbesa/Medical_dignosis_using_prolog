import tkinter as tk
from tkinter import messagebox

class DiagnosisApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Interactive Diagnosis System")
        
        # Initialize variables
        self.symptoms = [
            "fever", "cough", "sore_throat", "runny_nose", "headache", "fatigue", 
            "chest_pain", "shortness_of_breath", "body_aches", "nausea", "diarrhea", 
            "vomiting", "chills", "loss_of_taste_or_smell", "dizziness"
        ]
        self.diseases = {
            "flu": "Influenza, commonly known as the flu, is a viral infection that attacks the respiratory system.",
            "cold": "The common cold is a viral infection of your nose and throat (upper respiratory tract).",
            "covid19": "COVID-19 is a respiratory illness caused by the coronavirus SARS-CoV-2.",
            "pneumonia": "Pneumonia is an infection that inflames the air sacs in one or both lungs.",
            "stomach_flu": "Stomach flu (gastroenteritis) is an intestinal infection marked by nausea, diarrhea, and vomiting.",
            "malaria": "Malaria is a life-threatening disease caused by parasites transmitted through the bites of infected mosquitoes.",
            "migraine": "Migraine is a neurological condition that can cause multiple symptoms, including severe headache and dizziness."
        }
        
        self.disease_symptoms = {
            "flu": ["fever", "cough", "sore_throat", "headache", "body_aches", "chills"],
            "cold": ["runny_nose", "sore_throat", "cough", "headache", "fatigue"],
            "covid19": ["fever", "cough", "fatigue", "headache", "shortness_of_breath", "loss_of_taste_or_smell"],
            "pneumonia": ["fever", "cough", "chest_pain", "shortness_of_breath"],
            "stomach_flu": ["nausea", "diarrhea", "fatigue", "vomiting"],
            "malaria": ["fever", "chills", "body_aches", "nausea"],
            "migraine": ["headache", "dizziness", "nausea"]
        }

        self.responses = {}
        
        # Create GUI components
        self.create_widgets()

    def create_widgets(self):
        # Title label
        title_label = tk.Label(self.root, text="Welcome to the Interactive Diagnosis System", font=("Helvetica", 16))
        title_label.grid(row=0, column=0, columnspan=2, pady=10)

        # Menu options
        menu_frame = tk.Frame(self.root)
        menu_frame.grid(row=1, column=0, columnspan=2, pady=20)
        
        # Start Diagnosis Button
        start_button = tk.Button(menu_frame, text="Start Diagnosis", width=20, command=self.start_diagnosis)
        start_button.grid(row=0, column=0, padx=10)

        # View All Diseases Button
        all_diseases_button = tk.Button(menu_frame, text="View All Disease Details", width=20, command=self.view_all_diseases)
        all_diseases_button.grid(row=0, column=1, padx=10)

        # View Specific Disease Button
        specific_disease_button = tk.Button(menu_frame, text="View Specific Disease Details", width=20, command=self.view_specific_disease)
        specific_disease_button.grid(row=1, column=0, columnspan=2, pady=10)

    def start_diagnosis(self):
        # Clear previous responses
        self.responses.clear()
        
        # Ask user about each symptom
        self.ask_symptoms()

    def ask_symptoms(self):
        for symptom in self.symptoms:
            self.ask_symptom(symptom)

    def ask_symptom(self, symptom):
        # Ask user if they have the symptom
        response = messagebox.askyesno("Symptom Check", f"Do you have {symptom.replace('_', ' ')}?")
        
        if response:
            self.responses[symptom] = True
        else:
            self.responses[symptom] = False
        
        # Check for diagnosis after each answer
        self.check_diagnosis()

    def check_diagnosis(self):
        possible_diseases = []
        for disease, disease_symptoms in self.disease_symptoms.items():
            if all(self.responses.get(symptom, False) for symptom in disease_symptoms):
                possible_diseases.append(disease)
        
        # Show diagnosis results
        if possible_diseases:
            self.show_possible_diseases(possible_diseases)
        else:
            messagebox.showinfo("Diagnosis", "No exact match found for the symptoms.\nYou might have one of the following:")
            self.show_possible_diseases(self.diseases.keys())
    
    def show_possible_diseases(self, diseases):
        diseases_str = "\n".join(diseases)
        messagebox.showinfo("Diagnosis Results", f"Possible diseases:\n{diseases_str}")

    def view_all_diseases(self):
        # Display all disease details
        all_diseases_str = "\n".join([f"{name}: {desc}" for name, desc in self.diseases.items()])
        messagebox.showinfo("All Diseases", f"All Disease Information:\n{all_diseases_str}")

    def view_specific_disease(self):
        # Ask for disease name and display its details
        disease_name = self.ask_for_disease_name()
        disease_name = disease_name.lower().strip()
        
        if disease_name in self.diseases:
            disease_desc = self.diseases[disease_name]
            messagebox.showinfo(f"{disease_name.capitalize()} Details", f"Description: {disease_desc}")
        else:
            messagebox.showerror("Error", "Disease not found. Please try again.")

    def ask_for_disease_name(self):
        # Prompt user to enter disease name
        return tk.simpledialog.askstring("Disease Name", "Enter disease name (e.g., flu, covid19):")


# Run the application
if __name__ == "__main__":
    root = tk.Tk()
    app = DiagnosisApp(root)
    root.mainloop()
