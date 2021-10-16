# -*- coding: iso-8859-1 -*-
import time
import RPi.GPIO as GPIO
# Import the WS2801 module.
import Adafruit_WS2801
import Adafruit_GPIO.SPI as SPI
import lcddriver
import mysql.connector
from mysql.connector import Error
import json
import threading
#GPIO HANDLER

#Stop variable for display threading
DISPLAY_CHANGED = False
DISPLAY_STOP = False
#Display Object
STATE_CHOOSE_COCKTAIL = 1
STATE_MANUAL = 2
STATE_START_UP = 3
STATE_MAKING_COCKTAIL = 4
STATE = STATE_START_UP
PREV_STATE = None
#Pumpengeschwidnigkeit in ml/sekunde
#ZutatenID: geschwidnigkeit
PUMP_SPEED = {}
#ALCOHOL_ZUTATEN Abstufungen
ALC = [0.5, 1, 2]
CURRENT_ALC = 1
MENGE = [100, 200, 300, 400, 500]
CURRENT_MENGE = 1
#Display
DISPLAY = None
#JSON DATA
JSON_DATA = None
# Zuordnung der GPIO Pins der Buttons
BUTTONS = {}
#vertausche hier key value, beides wird gebraucht
NAMED_BUTTONS = {}

MANUELL_BUTTON_GPIO = None
# Zuordnung der GPIO Pins der Pumpen und die Zutaten die sie pumpen
#PumpenGPIO: ZutatenID
PUMPEN = {}
# Übersicht über alle Zutaten
#ZutatenID: Name
ZUTATEN = {}
#Übersichtn über zutaten keys die alkohol entahlten
ALCOHOL_ZUTATEN = []
# Übersicht über alle Cocktails
#CocktailID: Name
COCKTAILS = {}
# Übersicht über alle Zubereitungsschritte
#CocktailID:{Schrittnummer: Beschreibung}
ZUBEREITUNG = {}
# Übersicht über alle Mischverhältnisse
#CocktailID:{ZutatenID: NumberOfParts}
MIXING = {}
#Database Variables
DATABASE_LOGIN = {}

#Error State Variables
databaseError = True
#Interrupt Flags
INTERRUPT_FLAGS = {}#shitty aber sonst gehts net ausm loopiloopraus bei z.B. cocktailmaking und stop taster
CURRENT_COCKTAIL = None
CURRENT_ZUTAT = None
class Display(threading.Thread):
    def __init__(self):
        super(Display, self).__init__()
        self.cicleIndexUpper = 0
        self.displayWidth = 16
        self.text1 = "Initizializing"
        self.text2 = ""
        self.progress = None
        self.progressStart = None
        self.display = lcddriver.lcd()
        self.display.lcd_clear()
    def setProgress(self, tim):
        self.progress = tim
    def clearProgress(self):
        self.progress = None
        self.progressStart = None
    def setText(self, t1, t2):
        global DISPLAY_CHANGED
        str1 = t1
        str2 = t2
        if (len(t1)<16):
            filler = ""
            for i in range(16- len(t1)):
                filler = filler + " "
            str1 = t1 + filler
        if (len(t2)<16):
            filler = ""
            for i in range(16- len(t2)):
                filler = filler + " "
            str2 = t2 + filler
        self.text1 = str1
        self.text2 = str2
        DISPLAY_CHANGED = True
    def run(self):
        global DISPLAY_CHANGED, DISPLAY_STOP
        while(DISPLAY_STOP != True):
            if (DISPLAY_CHANGED):
                    self.display.lcd_display_string(self.text1, 1)
                    self.display.lcd_display_string(self.text2, 2)
                    DISPLAY_CHANGED = False
                    self.cicleIndexUpper = 0
                    self.cicleIndexLower = 0
            else:
                if self.progress != None:
                    if self.progressStart == None:
                        self.progressStart = time.time()
                        self.display.lcd_clear()
                        self.display.lcd_display_string("Making Cocktail ", 1)
                    else:
                        if(time.time()-self.progressStart >= self.progress):
                            self.progressStart = None
                            self.progress = None
                            self.display.lcd_display_string(self.text1, 1)
                            self.display.lcd_display_string(self.text2, 2)
                        else:
                            progressString = ""
                            numberOfBlocks = int(round((time.time() - self.progressStart)/(float(self.progress)/16)))
                            for i in range(numberOfBlocks):
                                progressString += "="
                            if numberOfBlocks < 16:
                                for i in range(16-numberOfBlocks):
                                    progressString += " "
                            self.display.lcd_display_string(progressString, 2)
                else:   
                    if (len(self.text1) <= 16):
                        pass
                    else:
                        #self.display.lcd_clear() no clears looks better
                        textRow1 = self.text1[self.cicleIndexUpper:16+self.cicleIndexUpper]
                        if (len(self.text1) - self.cicleIndexUpper < 16):
                            filler = ""
                            for i in range(16 - (len(self.text1) - self.cicleIndexUpper < 16)):
                                filler = filler + " "
                            textRow1 =  textRow1 + filler
                        self.display.lcd_display_string(textRow1, 1)
                        self.cicleIndexUpper += 1
                        if (self.cicleIndexUpper > len(self.text1)-1):
                            self.cicleIndexUpper = 0
                    if (len(self.text2) <= 16):
                        pass
                    else:
                        #self.display.lcd_clear() no clears looks better
                        textRow2 = self.text2[self.cicleIndexLower:16+self.cicleIndexLower]
                        if (len(self.text2) - self.cicleIndexLower < 16):
                            filler = ""
                            for i in range(16 - (len(self.text2) - self.cicleIndexLower < 16)):
                                filler = filler + " "
                            textRow2 =  textRow2 + filler
                        self.display.lcd_display_string(self.text2, 2)
                        self.cicleIndexLower += 1
                        if (self.cicleIndexLower > len(self.text2)-1):
                            self.cicleIndexLower = 0
                time.sleep(0.20)
    def clear(self):
        self.setText("", "")
def buttonStop():
    global PUMPEN, INTERRUPT_FLAGS, NAMED_BUTTONS, STATE, STATE_MAKING_COCKTAIL, STATE_CHOOSE_COCKTAIL, DISPLAY
    for key, value in PUMPEN.items():
        GPIO.output(key, 1)
    INTERRUPT_FLAGS[NAMED_BUTTONS["stop"]] = False
    DISPLAY.clearProgress()
    if STATE == STATE_MAKING_COCKTAIL:
        STATE = STATE_CHOOSE_COCKTAIL
def clearInterrupts():
    global INTERRUPT_FLAGS
    for key,value in INTERRUPT_FLAGS.items():
        INTERRUPT_FLAGS[key] = False
def buttonStart():
    global STATE_CHOOSE_COCKTAIL, STATE_MANUAL, STATE_MAKING_COCKTAIL, STATE, NAMED_BUTTONS, INTERRUPT_FLAGS, PREV_STATE
    INTERRUPT_FLAGS[NAMED_BUTTONS["start"]] = False
    if STATE == STATE_CHOOSE_COCKTAIL and CURRENT_COCKTAIL != -1:
        makeCocktail(CURRENT_COCKTAIL)
        showCurrentItem()
    elif STATE == STATE_CHOOSE_COCKTAIL and CURRENT_COCKTAIL == -1:
        PREV_STATE = STATE
        STATE = STATE_MANUAL
        showCurrentItem()
    elif STATE == STATE_MANUAL and CURRENT_ZUTAT == -1:
        PREV_STATE = STATE
        STATE = STATE_CHOOSE_COCKTAIL
        resetItems()
    elif STATE == STATE_MANUAL:
        showInfo("Manuelle Auswahl", "Benutze Manuellen Button")
    else:
        pass
def buttonNext():
    global STATE_CHOOSE_COCKTAIL, STATE_MANUAL, STATE_MAKING_COCKTAIL, STATE, NAMED_BUTTONS, INTERRUPT_FLAGS
    if STATE == STATE_CHOOSE_COCKTAIL or STATE == STATE_MANUAL:
        showNextItem()
    else:
        pass
    INTERRUPT_FLAGS[NAMED_BUTTONS["next"]] = False
def buttonPrev():
    global STATE_CHOOSE_COCKTAIL, STATE_MANUAL, STATE_MAKING_COCKTAIL, STATE, NAMED_BUTTONS, INTERRUPT_FLAGS
    if STATE == STATE_CHOOSE_COCKTAIL or STATE == STATE_MANUAL:
        showPrevItem()
    else:
        pass
    INTERRUPT_FLAGS[NAMED_BUTTONS["prev"]] = False
def buttonReload():
    global STATE, PREV_STATE, STATE_CHOOSE_COCKTAIL, INTERRUPT_FLAGS, NAMED_BUTTONS, INTERRUPT_FLAGS, STATE_START_UP
    showInfo("Nicht druecken!", "Du Depp", 3)
    if STATE != STATE_MAKING_COCKTAIL:
        buttonStop()
        getDatabaseData()
        PREV_STATE = STATE_START_UP
        STATE = STATE_CHOOSE_COCKTAIL
        resetItems()
        showCurrentItem()
    INTERRUPT_FLAGS[NAMED_BUTTONS["reload"]] = False
def buttonAlc():
    global ALC, CURRENT_ALC, STATE_MAKING_COCKTAIL, STATE_MANUAL, STATE, NAMED_BUTTONS, INTERRUPT_FLAGS
    if (STATE != STATE_MAKING_COCKTAIL) and (STATE != STATE_MANUAL):
        if (CURRENT_ALC >= (len(ALC)-1)):
            CURRENT_ALC = 0
            showInfo("Alk Multiplier:", (str(ALC[CURRENT_ALC]) + "x"), 2)  
        else:
            CURRENT_ALC += 1
            showInfo("Alk Multiplier:", (str(ALC[CURRENT_ALC]) + "x"), 2)     
    INTERRUPT_FLAGS[NAMED_BUTTONS["alc"]] = False
def buttonQuantity():
    global MENGE, CURRENT_MENGE, STATE_MAKING_COCKTAIL, STATE_MANUAL, STATE, NAMED_BUTTONS, INTERRUPT_FLAGS
    if (STATE != STATE_MAKING_COCKTAIL) and (STATE != STATE_MANUAL):
        if (CURRENT_MENGE >= (len(MENGE)-1)):
            CURRENT_MENGE = 0
            showInfo("Neuer Menge: ", (str(MENGE[CURRENT_MENGE]) + " ml"), 2) 
        else:
            CURRENT_MENGE += 1
            showInfo("Neuer Menge: ", (str(MENGE[CURRENT_MENGE]) + " ml"), 2)
    INTERRUPT_FLAGS[NAMED_BUTTONS["quantity"]] = False
def handlestartUp():
    global DISPLAY, INTERRUPT_FLAGS, STATE, STATE_CHOOSE_COCKTAIL, PREV_STATE, COCKTAILS, CURRENT_COCKTAIL, STATE_START_UP 
    clearInterrupts()
    PREV_STATE = STATE_START_UP
    getPumpsReady()
    STATE = STATE_CHOOSE_COCKTAIL
    showCurrentItem()
def exit():
    for key, value in BUTTONS.items():
        if value != "manual":
            GPIO.remove_event_detect(key)
    GPIO.cleanup()
def importJson(path):
    global BUTTONS
    global NAMED_BUTTONS
    global DATABASE_LOGIN
    with open(path) as json_file:
        JSON_DATA = json.load(json_file)
        data = JSON_DATA["Buttons"]
        for key, value in data.items():
            BUTTONS[value] = str(key)
            NAMED_BUTTONS[str(key)] = value
        data = JSON_DATA["dbInfo"]
        for key, value in data.items():
            DATABASE_LOGIN[str(key)] = str(value)
# debouncedInput reads the specified GPIO pin and 
# returns the first state (0 or 1) that we read three times in a row
def debouncedInput(pin):
    tries = 12
    i, ones, zeroes = 0, 0, 0
    while i < tries:
        bit=GPIO.input(pin)
        if (bit == 1):
           ones = ones + 1
           zeroes = 0
        else:
           zeroes = zeroes + 1
           ones = 0
        i = i + 1
        if (ones >= 3):
            return 1
        if (zeroes >=3):
            return 0
        time.sleep(0.01) # wait a bit

    # indeterminate state, tries exhausted
    logging.error ('Bouncy input: %s', pin) 
    return (bit)   #best effort 
def buttonInterrupt(channel):
    global BUTTONS, STATE
    if debouncedInput(channel) == 0:
        print(BUTTONS[channel])
        INTERRUPT_FLAGS[channel]=True
        if(channel == NAMED_BUTTONS["stop"]):
            buttonStop()    
def gpioInit():
    global MANUELL_BUTTON_GPIO
    GPIO.setmode(GPIO.BCM) # Use GPIO Pin Numbering
    for key, value in BUTTONS.items():
        GPIO.setup(key,GPIO.IN, pull_up_down=GPIO.PUD_UP)
        if value != "manual":
            GPIO.add_event_detect(key, GPIO.FALLING, callback=buttonInterrupt, bouncetime=300)
            INTERRUPT_FLAGS[key]= False
        else:
            MANUELL_BUTTON_GPIO = key
    PUMPEN.items()        
    for key, value in PUMPEN.items():
        GPIO.setup(key,GPIO.OUT)
        GPIO.output(key, 1)
def getDatabaseData(showItem = False):
    try:
        CON = mysql.connector.connect(host=DATABASE_LOGIN['host'], database=DATABASE_LOGIN['database'], user=DATABASE_LOGIN['user'], password=DATABASE_LOGIN['password'])
        if CON.is_connected():
            global PUMPEN, ZUTATEN, ZUBEREITUNG, MIXING, COCKTAILS, CURRENT_COCKTAIL, CURRENT_ZUTAT, ALCOHOL_ZUTATEN, PUMP_SPEED
            databaseError = False
            cursor = CON.cursor()
            #Get Pumpen Data
            query = "SELECT * FROM Pumpe;"
            cursor.execute(query)
            result = cursor.fetchall()
            for elem in result:
                PUMPEN[elem[1]] = elem[2]
            #Get Zutaten Data
            query = "SELECT * FROM Zutat;"
            cursor.execute(query)
            result = cursor.fetchall()
            for elem in result:
                if str(elem[1]) != "None":
                    ZUTATEN[elem[0]] = str(elem[1])
                    if elem[2] == 1:
                        ALCOHOL_ZUTATEN.append(elem[0])
                    PUMP_SPEED[elem[0]] = elem[3]
            ZUTATEN[-1] = "Zurueck"
            CURRENT_ZUTAT = ZUTATEN.keys()[0]
            #Get Cocktail Zubereitung
            query = "SELECT * FROM (Cocktail JOIN Zubereitungsschritt ON Cocktail.CocktailID = Zubereitungsschritt.schrittCocktailID) ORDER BY SchrittNummer ASC;"
            cursor.execute(query)
            result = cursor.fetchall()
            for elem in result:
                if elem[0] in ZUBEREITUNG:
                    ZUBEREITUNG[elem[0]][elem[3]] =  str(elem[4])
                else:
                    ZUBEREITUNG[elem[0]] = {elem[3]: str(elem[4])}
            #Putzen Zubereitung
            ZUBEREITUNG[-2] = {1: "Bitte ALLE Schlauche in ein Gefaess mit Seifenwasser geben"}
            ZUBEREITUNG[-2][2] = "go"
            ZUBEREITUNG[-2][3] = "Bitte ALLE Schlauche in ein Gefaess mit WASSER geben"
            ZUBEREITUNG[-2][4] = "go"
            ZUBEREITUNG[-2][5] = "Bitte ALLE Schlaeuche Luft ansaugen lassen"
            ZUBEREITUNG[-2][6] = "go"      
            #Get Cocktail Mischverhältnisse
            query = "SELECT * FROM (Cocktail JOIN xRefCocktailZutat ON Cocktail.CocktailID = xRefCocktailZutat.xRefCocktailID );"
            cursor.execute(query)
            result = cursor.fetchall()
            for elem in result:
                if elem[0] in MIXING:
                    MIXING[elem[0]][elem[4]] =  elem[5]
                else:
                    MIXING[elem[0]] = {elem[4]: elem[5]}
            for key, value in ZUTATEN.items():
                if key != -1: #Zurueck button
                    if -2 in MIXING:
                        MIXING[-2][key] = PUMP_SPEED[key]
                    else:
                        MIXING[-2] = {key: PUMP_SPEED[key]}
            #Get Cocktails
            query = "SELECT * FROM Cocktail;"
            cursor.execute(query)
            result = cursor.fetchall()
            for elem in result:
                COCKTAILS[elem[0]] =  str(elem[1])
            #make appaer putzen as last item, idk why, but it mixes up the indexes when the len of the dict is even or odd
            if(len(COCKTAILS)%2 == 1):
                COCKTAILS[-1] = "Manuelle Auswahl"
                COCKTAILS[-2] = "Putzen"
            else:
                COCKTAILS[-2] = "Putzen"
                COCKTAILS[-1] = "Manuelle Auswahl"
            CURRENT_COCKTAIL = COCKTAILS.keys()[0]
            print(COCKTAILS)
            if showItem:
                showCurrentItem()
    except Error as e:
        databaseError = True
        print("Error while connecting to MySQL", e)
def printLines(string1, string2):
    global DISPLAY
    DISPLAY.setText(string1, string2)
def showInfo(text1,text2, dur = 2):
    printLines(text1, text2)
    time.sleep(dur)
    showCurrentItem()
def showCurrentItem():
    global COCKTAILS, CURRENT_COCKTAIL, CURRENT_ZUTAT, ZUTATEN, STATE, STATE_CHOOSE_COCKTAIL, STATE_MANUAL
    if (STATE == STATE_CHOOSE_COCKTAIL):
        printLines(str(COCKTAILS[CURRENT_COCKTAIL]), "Druecke Start")
    elif(STATE ==STATE_MANUAL):
        printLines(str(ZUTATEN[CURRENT_ZUTAT]), "Druecke Manuell")
def showNextItem():
    global COCKTAILS
    global CURRENT_COCKTAIL
    global CURRENT_ZUTAT
    global ZUTATEN
    if (STATE == STATE_CHOOSE_COCKTAIL):
        for i in range(len(COCKTAILS.keys())):
            if COCKTAILS.keys()[i] == CURRENT_COCKTAIL:
                if (i < len(COCKTAILS.keys())-1):
                    CURRENT_COCKTAIL = COCKTAILS.keys()[i+1]
                    break
    elif(STATE ==STATE_MANUAL):
        for i in range(len(ZUTATEN.keys())):
            if (ZUTATEN.keys()[i] == CURRENT_ZUTAT):
                if (i < len(ZUTATEN.keys())-1):
                    CURRENT_ZUTAT = ZUTATEN.keys()[i+1]
                    break
    showCurrentItem()
def showPrevItem():
    global CURRENT_ZUTAT
    global ZUTATEN
    global COCKTAILS
    global CURRENT_COCKTAIL
    if (STATE == STATE_CHOOSE_COCKTAIL):
        for i in range(len(COCKTAILS.keys())):
            if COCKTAILS.keys()[i] == CURRENT_COCKTAIL:
                if (i > 0):
                    CURRENT_COCKTAIL = COCKTAILS.keys()[i-1]
                    break
    elif(STATE ==STATE_MANUAL):
        for i in range(len(ZUTATEN.keys())):
            if ZUTATEN.keys()[i] == CURRENT_ZUTAT:
                if (i > 0):
                    CURRENT_ZUTAT = ZUTATEN.keys()[i-1]
                    break
    showCurrentItem()
def resetItems():
    global CURRENT_ZUTAT
    global ZUTATEN
    global COCKTAILS
    global CURRENT_COCKTAIL
    CURRENT_ZUTAT = ZUTATEN.keys()[0]
    CURRENT_COCKTAIL = COCKTAILS.keys()[0]
    showCurrentItem()
def getPumpsReady():
    return 0
    #GEtränke durch die Schläuche anziehen
def makeCocktail(id):
    global COCKTAILS, MIXING, ZUBEREITUNG, ZUTATEN, PUMPEN, STATE, PREV_STATE, STATE_MAKING_COCKTAIL, INTERRUPT_FLAGS, NAMED_BUTTONS, ALCOHOL_ZUTATEN, CURRENT_MENGE, CURRENT_ALC, PUMP_SPEED, ALC, MENGE
    STATE = STATE_MAKING_COCKTAIL 
    count = 1
    for key, value in ZUBEREITUNG[id].items():
        print("Count: ", count)
        count +=1
        print(ZUBEREITUNG[id].items())
        print(value)
        if value == "go":
            ges = 0
            for key, value in MIXING[id].items():
                if key in ALCOHOL_ZUTATEN:
                    ges += value*ALC[CURRENT_ALC]
                else:
                    ges += value
            print("Gesamtanteile:" ,  ges)
            print(MIXING[id])
            pumpMenge = {}
            timePerPump = {}
            print(MENGE[CURRENT_MENGE])
            print(PUMP_SPEED)
            if id == -2:#Putzen
                for key, value in PUMPEN.items():
                            timePerPump[key] = 60
            else:
                for key, value in MIXING[id].items():
                    if key in ALCOHOL_ZUTATEN:
                        pumpMenge[key] = (float(MENGE[CURRENT_MENGE])/ges)*(value*ALC[CURRENT_ALC])
                    else:
                        pumpMenge[key] = (float(MENGE[CURRENT_MENGE])/ges)*value
                print(pumpMenge)
                for key, value in pumpMenge.items():
                    for k,v in PUMPEN.items():
                        if v == key:
                            timePerPump[k] = (value/PUMP_SPEED[key])
            startTime = time.time()
            print("Set value:" , max(timePerPump.values()))
            DISPLAY.setProgress(max(timePerPump.values()))
            finishedPumps = []
            for key, value in timePerPump.items():
                GPIO.output(key, 0)
            doNotBreakOut = 1
            while(STATE == STATE_MAKING_COCKTAIL  and doNotBreakOut):
                for key, value in timePerPump.items():
                        if (time.time()-startTime)>= value:
                            if key not in finishedPumps:
                                GPIO.output(key, 1)
                                finishedPumps.append(key)
                        if (len(finishedPumps) == len(timePerPump)):
                            doNotBreakOut = 0
                            break
                time.sleep(0.1)
        else:
            printLines(value, "Druecke Start")
            while(INTERRUPT_FLAGS[NAMED_BUTTONS["start"]] != True):
                if STATE != STATE_MAKING_COCKTAIL:
                    showCurrentItem()
                    return
                time.sleep(0.1)
            INTERRUPT_FLAGS[NAMED_BUTTONS["start"]] = False
    STATE = STATE_CHOOSE_COCKTAIL
    showCurrentItem()
    return


if __name__ == '__main__':
    try:
        DISPLAY = Display()
        DISPLAY.start()
        printLines("Baudinis Cocktail Maker", "Welcome Welcome")
        time.sleep(10)
        # initialisieren
        importJson("data.json")
        getDatabaseData()
        gpioInit()

        handlestartUp()
        while(True):
            if True in INTERRUPT_FLAGS.values():
                for key, value in INTERRUPT_FLAGS.items():
                    if(BUTTONS[key] == "next") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonNext()
                    elif (BUTTONS[key] == "prev") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonPrev()
                    elif (BUTTONS[key] == "start") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonStart()
                    elif (BUTTONS[key] == "reload") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonReload()
                    elif (BUTTONS[key] == "quantity") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonQuantity()
                    elif (BUTTONS[key] == "alc") and (value == True) and (GPIO.input(MANUELL_BUTTON_GPIO) == 1):
                        buttonAlc()
            if STATE == STATE_MANUAL:
                if (GPIO.input(MANUELL_BUTTON_GPIO) == 0):
                    for key, value in PUMPEN.items():
                        if value == CURRENT_ZUTAT:
                            printLines(ZUTATEN[CURRENT_ZUTAT], "PUMPO PUMPO")
                            GPIO.output(key, 0)
                else:
                    
                    buttonStop()
                    showCurrentItem()
                    
            time.sleep(0.1)

    except KeyboardInterrupt:
        DISPLAY.clear()
        DISPLAY_STOP =  True
        exit()
        print("Stopping")