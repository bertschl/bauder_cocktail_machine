import time
import RPi.GPIO as GPIO
import time

# Zuordnung der GPIO Pins (ggf. anpassen)
OUT = 2
PUMPEN = 6
BUTTON = 13
GPIO.setmode(GPIO.BCM) # Use GPIO Pin Numbering
GPIO.setup(BUTTON,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(OUT,GPIO.OUT)
GPIO.setup(PUMPEN,GPIO.OUT)
GPIO.output(OUT, GPIO.HIGH)
GPIO.output(PUMPEN, GPIO.LOW)
while True: # Run forever
    if GPIO.input(BUTTON) == 1:
        print("Button was pushed!")
        if(GPIO.input(PUMPEN) == 0):
            GPIO.output(PUMPEN, GPIO.HIGH)
        else:
            GPIO.output(PUMPEN, GPIO.LOW)
        time.sleep(2)
        