Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaE0HLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:11:32 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59129 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaE0HLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:11:30 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, jic23@kernel.org,
        linux-input@vger.kernel.org, jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCHv2] HID: Debug: Add labels for HID Sensor Usages
Date: Tue, 27 May 2014 02:10:59 -0500
Message-Id: <1401174659-2480-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in debugfs report descriptor labels for HID Sensor Usages.

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/hid/hid-debug.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 53b771d..25cc71c 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -272,6 +272,85 @@ static const struct hid_usage_entry hid_usage_table[] = {
     {0, 0xAA, "Shared_Parameter_Blocks"},
     {0, 0xAB, "Create_New_Effect_Report"},
     {0, 0xAC, "RAM_Pool_Available"},
+  {  0x20, 0, "Sensor" },
+    { 0x20, 0x01, "Sensor" },
+    { 0x20, 0x10, "Biometric" },
+      { 0x20, 0x11, "BiometricHumanPresence" },
+      { 0x20, 0x12, "BiometricHumanProximity" },
+      { 0x20, 0x13, "BiometricHumanTouch" },
+    { 0x20, 0x20, "Electrical" },
+      { 0x20, 0x21, "ElectricalCapacitance" },
+      { 0x20, 0x22, "ElectricalCurrent" },
+      { 0x20, 0x23, "ElectricalPower" },
+      { 0x20, 0x24, "ElectricalInductance" },
+      { 0x20, 0x25, "ElectricalResistance" },
+      { 0x20, 0x26, "ElectricalVoltage" },
+      { 0x20, 0x27, "ElectricalPoteniometer" },
+      { 0x20, 0x28, "ElectricalFrequency" },
+      { 0x20, 0x29, "ElectricalPeriod" },
+    { 0x20, 0x30, "Environmental" },
+      { 0x20, 0x31, "EnvironmentalAtmosphericPressure" },
+      { 0x20, 0x32, "EnvironmentalHumidity" },
+      { 0x20, 0x33, "EnvironmentalTemperature" },
+      { 0x20, 0x34, "EnvironmentalWindDirection" },
+      { 0x20, 0x35, "EnvironmentalWindSpeed" },
+    { 0x20, 0x40, "Light" },
+      { 0x20, 0x41, "LightAmbientLight" },
+      { 0x20, 0x42, "LightConsumerInfrared" },
+    { 0x20, 0x50, "Location" },
+      { 0x20, 0x51, "LocationBroadcast" },
+      { 0x20, 0x52, "LocationDeadReckoning" },
+      { 0x20, 0x53, "LocationGPS" },
+      { 0x20, 0x54, "LocationLookup" },
+      { 0x20, 0x55, "LocationOther" },
+      { 0x20, 0x56, "LocationStatic" },
+      { 0x20, 0x57, "LocationTriangulation" },
+    { 0x20, 0x60, "Mechanical" },
+      { 0x20, 0x61, "MechanicalBooleanSwitch" },
+      { 0x20, 0x62, "MechanicalBooleanSwitchArray" },
+      { 0x20, 0x63, "MechanicalMultivalueSwitch" },
+      { 0x20, 0x64, "MechanicalForce" },
+      { 0x20, 0x65, "MechanicalPressure" },
+      { 0x20, 0x66, "MechanicalStrain" },
+      { 0x20, 0x67, "MechanicalWeight" },
+      { 0x20, 0x68, "MechanicalHapticVibrator" },
+      { 0x20, 0x69, "MechanicalHallEffectSwitch" },
+    { 0x20, 0x70, "Motion" },
+      { 0x20, 0x71, "MotionAccelerometer1D" },
+      { 0x20, 0x72, "MotionAccelerometer2D" },
+      { 0x20, 0x73, "MotionAccelerometer3D" },
+      { 0x20, 0x74, "MotionGyrometer1D" },
+      { 0x20, 0x75, "MotionGyrometer2D" },
+      { 0x20, 0x76, "MotionGyrometer3D" },
+      { 0x20, 0x77, "MotionMotionDetector" },
+      { 0x20, 0x78, "MotionSpeedometer" },
+      { 0x20, 0x79, "MotionAccelerometer" },
+      { 0x20, 0x7A, "MotionGyrometer" },
+    { 0x20, 0x80, "Orientation" },
+      { 0x20, 0x81, "OrientationCompass1D" },
+      { 0x20, 0x82, "OrientationCompass2D" },
+      { 0x20, 0x83, "OrientationCompass3D" },
+      { 0x20, 0x84, "OrientationInclinometer1D" },
+      { 0x20, 0x85, "OrientationInclinometer2D" },
+      { 0x20, 0x86, "OrientationInclinometer3D" },
+      { 0x20, 0x87, "OrientationDistance1D" },
+      { 0x20, 0x88, "OrientationDistance2D" },
+      { 0x20, 0x89, "OrientationDistance3D" },
+      { 0x20, 0x8A, "OrientationDeviceOrientation" },
+      { 0x20, 0x8B, "OrientationCompass" },
+      { 0x20, 0x8C, "OrientationInclinometer" },
+      { 0x20, 0x8D, "OrientationDistance" },
+    { 0x20, 0x90, "Scanner" },
+      { 0x20, 0x91, "ScannerBarcode" },
+      { 0x20, 0x91, "ScannerRFID" },
+      { 0x20, 0x91, "ScannerNFC" },
+    { 0x20, 0xA0, "Time" },
+      { 0x20, 0xA1, "TimeAlarmTimer" },
+      { 0x20, 0xA2, "TimeRealTimeClock" },
+    { 0x20, 0xE0, "Other" },
+      { 0x20, 0xE1, "OtherCustom" },
+      { 0x20, 0xE2, "OtherGeneric" },
+      { 0x20, 0xE3, "OtherGenericEnumerator" },
   { 0x84, 0, "Power Device" },
     { 0x84, 0x02, "PresentStatus" },
     { 0x84, 0x03, "ChangeStatus" },
-- 
1.9.0

