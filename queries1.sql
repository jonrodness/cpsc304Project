########User: Pharmacists

#view prescriptions prescribed by doctor
#chris
select Pr.PrescriptID
from Prescription Pr, Doctor D
where Pr.LicenseNum=D.LicenseNum;

#change status of prescription (not ready for pick up, ready for pick up) (**need to add as attribute)
#can view past prescriptions for patient
#can print out a list of prescriptions filled that day
#can reduce the refill number of a patient’s prescription

########User: Patients

#update personal information about him/herself

#can input an address and a radius and see a list of doctors offices within the indicated radius of the indicated address
#select doctor attributes from doctor tables and filter by attributes
#select pharmacies that are currently open
#given a date/time, view pharmacies that are open at that date/time
#can input an address and a radius and as a result, can view a list of pharmacies that are open at the moment , within the indicated radius of the indicated address
#request permission to add a doctor to their personal list of doctors
#can select a personal doctor by name and last name and view a list of time blocks when the doctor is available
#can create an appointment with any doctor at any given time, as long as the doctor is available during that time and the appointment is within business hours
#can cancel an appointment they made, by looking at the list of self booked appointments
#can view upcoming appointments, on a certain date(optional) and during a certain time(optional)
#can (quickly)check if he/she took a certain drug before
#can view a list of drugs that interact with a specific drug
#can input a prescription ID and view a list of drugs that interact with this prescription
#can view status of prescription pick up (ready or not for pickup)
#Generate a report about what prescriptions a patient is currently using, when they were prescribed, and which doctor prescribed them, as well as which pharmacies have them in stock currently
#second analogous report, but for previous prescriptions (not current)


########User: Doctors
#can update personal information about him/herself
#can prescribe a drug
#same as the patient ^^^
#can view a list of pharmacies that are open at the moment
#can view a list of pharmacies that are open on a certain date and time(optional)
#can input an address and a radius and as a result, can view a list of pharmacies that are open at the moment , within the indicated radius of the indicated address
#can view a list of all appointments for any picked date and any picked time
#can register a patient who requested his/her services
#can view personal information about a patient 
#can view a list of previous prescriptions for a certain patient
#can view a list of previous drugs taken by a certain patient
#can check if a certain drug was taken in the past by a certain patient
#can view a list of drugs that interact with a specific drug  (same as patient)
#notified when patients cancel an appointment
#can view a list of past appointments by a certain patient
#Generate a report about which prescriptions a doctor has previously prescribed, and to whom the prescriptions were prescribed, as well as which pharmacy filled the prescription
