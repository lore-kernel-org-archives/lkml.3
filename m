Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3HAXrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:47:43 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:53462 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3HAXrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:47:39 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 1/3] acpi: video: trivial costmetic cleanups
Date: Thu,  1 Aug 2013 18:43:59 -0500
Message-Id: <1375400641-1694-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/acpi/video.c | 114 +++++++++++++++++++++++++++------------------------
 1 file changed, 61 insertions(+), 53 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0ec434d..f021bf4 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1,5 +1,5 @@
 /*
- *  video.c - ACPI Video Driver ($Revision:$)
+ *  video.c - ACPI Video Driver
  *
  *  Copyright (C) 2004 Luming Yu <luming.yu@intel.com>
  *  Copyright (C) 2004 Bruno Ducrot <ducrot@poupinou.org>
@@ -118,26 +118,26 @@ struct acpi_video_bus_flags {
 };
 
 struct acpi_video_bus_cap {
-	u8 _DOS:1;		/*Enable/Disable output switching */
-	u8 _DOD:1;		/*Enumerate all devices attached to display adapter */
-	u8 _ROM:1;		/*Get ROM Data */
-	u8 _GPD:1;		/*Get POST Device */
-	u8 _SPD:1;		/*Set POST Device */
-	u8 _VPO:1;		/*Video POST Options */
+	u8 _DOS:1;		/* Enable/Disable output switching */
+	u8 _DOD:1;		/* Enumerate all devices attached to display adapter */
+	u8 _ROM:1;		/* Get ROM Data */
+	u8 _GPD:1;		/* Get POST Device */
+	u8 _SPD:1;		/* Set POST Device */
+	u8 _VPO:1;		/* Video POST Options */
 	u8 reserved:2;
 };
 
 struct acpi_video_device_attrib {
 	u32 display_index:4;	/* A zero-based instance of the Display */
-	u32 display_port_attachment:4;	/*This field differentiates the display type */
-	u32 display_type:4;	/*Describe the specific type in use */
-	u32 vendor_specific:4;	/*Chipset Vendor Specific */
-	u32 bios_can_detect:1;	/*BIOS can detect the device */
-	u32 depend_on_vga:1;	/*Non-VGA output device whose power is related to 
+	u32 display_port_attachment:4;	/* This field differentiates the display type */
+	u32 display_type:4;	/* Describe the specific type in use */
+	u32 vendor_specific:4;	/* Chipset Vendor Specific */
+	u32 bios_can_detect:1;	/* BIOS can detect the device */
+	u32 depend_on_vga:1;	/* Non-VGA output device whose power is related to
 				   the VGA device. */
-	u32 pipe_id:3;		/*For VGA multiple-head devices. */
-	u32 reserved:10;	/*Must be 0 */
-	u32 device_id_scheme:1;	/*Device ID Scheme */
+	u32 pipe_id:3;		/* For VGA multiple-head devices. */
+	u32 reserved:10;	/* Must be 0 */
+	u32 device_id_scheme:1;	/* Device ID Scheme */
 };
 
 struct acpi_video_enumerated_device {
@@ -174,17 +174,17 @@ struct acpi_video_device_flags {
 };
 
 struct acpi_video_device_cap {
-	u8 _ADR:1;		/*Return the unique ID */
-	u8 _BCL:1;		/*Query list of brightness control levels supported */
-	u8 _BCM:1;		/*Set the brightness level */
+	u8 _ADR:1;		/* Return the unique ID */
+	u8 _BCL:1;		/* Query list of brightness control levels supported */
+	u8 _BCM:1;		/* Set the brightness level */
 	u8 _BQC:1;		/* Get current brightness level */
 	u8 _BCQ:1;		/* Some buggy BIOS uses _BCQ instead of _BQC */
-	u8 _DDC:1;		/*Return the EDID for this device */
+	u8 _DDC:1;		/* Return the EDID for this device */
 };
 
 struct acpi_video_brightness_flags {
 	u8 _BCL_no_ac_battery_levels:1;	/* no AC/Battery levels in _BCL */
-	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order*/
+	u8 _BCL_reversed:1;		/* _BCL package is in a reversed order */
 	u8 _BCL_use_index:1;		/* levels in _BCL are index values */
 	u8 _BCM_use_index:1;		/* input of _BCM is an index value */
 	u8 _BQC_use_index:1;		/* _BQC returns an index value */
@@ -231,7 +231,7 @@ static int acpi_video_get_next_level(struct acpi_video_device *device,
 static int acpi_video_switch_brightness(struct acpi_video_device *device,
 					 int event);
 
-/*backlight device sysfs support*/
+/* backlight device sysfs support */
 static int acpi_video_get_brightness(struct backlight_device *bd)
 {
 	unsigned long long cur_level;
@@ -243,8 +243,10 @@ static int acpi_video_get_brightness(struct backlight_device *bd)
 		return -EINVAL;
 	for (i = 2; i < vd->brightness->count; i++) {
 		if (vd->brightness->levels[i] == cur_level)
-			/* The first two entries are special - see page 575
-			   of the ACPI spec 3.0 */
+			/*
+			 * The first two entries are special - see page 575
+			 * of the ACPI spec 3.0
+			 */
 			return i-2;
 	}
 	return 0;
@@ -316,9 +318,11 @@ static const struct thermal_cooling_device_ops video_cooling_ops = {
 	.set_cur_state = video_set_cur_state,
 };
 
-/* --------------------------------------------------------------------------
-                               Video Management
-   -------------------------------------------------------------------------- */
+/*
+ * --------------------------------------------------------------------------
+ *                             Video Management
+ * --------------------------------------------------------------------------
+ */
 
 static int
 acpi_video_device_lcd_query_levels(struct acpi_video_device *device,
@@ -556,7 +560,8 @@ acpi_video_device_lcd_get_level_current(struct acpi_video_device *device,
 				      buf));
 			device->cap._BQC = device->cap._BCQ = 0;
 		} else {
-			/* Fixme:
+			/*
+			 * Fixme:
 			 * should we return an error or ignore this failure?
 			 * dev->brightness->curr is a cached value which stores
 			 * the correct current backlight level in most cases.
@@ -615,8 +620,8 @@ acpi_video_device_EDID(struct acpi_video_device *device,
 
 /*
  *  Arg:
- *  	video		: video bus device pointer
- *	bios_flag	: 
+ *	video		: video bus device pointer
+ *	bios_flag	:
  *		0.	The system BIOS should NOT automatically switch(toggle)
  *			the active display output.
  *		1.	The system BIOS should automatically switch (toggle) the
@@ -628,9 +633,9 @@ acpi_video_device_EDID(struct acpi_video_device *device,
  *	lcd_flag	:
  *		0.	The system BIOS should automatically control the brightness level
  *			of the LCD when the power changes from AC to DC
- *		1. 	The system BIOS should NOT automatically control the brightness 
+ *		1.	The system BIOS should NOT automatically control the brightness
  *			level of the LCD when the power changes from AC to DC.
- * Return Value:
+ *  Return Value:
  *		-EINVAL	wrong arg.
  */
 
@@ -717,8 +722,8 @@ static int acpi_video_bqc_quirk(struct acpi_video_device *device,
 
 
 /*
- *  Arg:	
- *  	device	: video output device (LCD, CRT, ..)
+ *  Arg:
+ *	device	: video output device (LCD, CRT, ..)
  *
  *  Return Value:
  *	Maximum brightness level
@@ -877,7 +882,7 @@ out:
  *	device	: video output device (LCD, CRT, ..)
  *
  *  Return Value:
- *  	None
+ *	None
  *
  *  Find out all required AML methods defined under the output
  *  device.
@@ -988,11 +993,11 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 }
 
 /*
- *  Arg:	
- *  	device	: video output device (VGA)
+ *  Arg:
+ *	device	: video output device (VGA)
  *
  *  Return Value:
- *  	None
+ *	None
  *
  *  Find out all required AML methods defined under the video bus device.
  */
@@ -1039,7 +1044,8 @@ static int acpi_video_bus_check(struct acpi_video_bus *video)
 		return -ENODEV;
 	pci_dev_put(dev);
 
-	/* Since there is no HID, CID and so on for VGA driver, we have
+	/*
+	 * Since there is no HID, CID and so on for VGA driver, we have
 	 * to check well known required nodes.
 	 */
 
@@ -1069,9 +1075,11 @@ static int acpi_video_bus_check(struct acpi_video_bus *video)
 	return status;
 }
 
-/* --------------------------------------------------------------------------
-                                 Driver Interface
-   -------------------------------------------------------------------------- */
+/*
+ * --------------------------------------------------------------------------
+ *                               Driver Interface
+ * --------------------------------------------------------------------------
+ */
 
 /* device interface */
 static struct acpi_video_device_attrib*
@@ -1192,12 +1200,12 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 
 /*
  *  Arg:
- *  	video	: video bus device 
+ *	video	: video bus device
  *
  *  Return:
- *  	none
- *  
- *  Enumerate the video device list of the video bus, 
+ *	none
+ *
+ *  Enumerate the video device list of the video bus,
  *  bind the ids with the corresponding video devices
  *  under the video bus.
  */
@@ -1216,13 +1224,13 @@ static void acpi_video_device_rebind(struct acpi_video_bus *video)
 
 /*
  *  Arg:
- *  	video	: video bus device 
- *  	device	: video output device under the video 
- *  		bus
+ *	video	: video bus device
+ *	device	: video output device under the video
+ *		bus
  *
  *  Return:
- *  	none
- *  
+ *	none
+ *
  *  Bind the ids with the corresponding video devices
  *  under the video bus.
  */
@@ -1245,11 +1253,11 @@ acpi_video_device_bind(struct acpi_video_bus *video,
 
 /*
  *  Arg:
- *  	video	: video bus device 
+ *	video	: video bus device
  *
  *  Return:
- *  	< 0	: error
- *  
+ *	< 0	: error
+ *
  *  Call _DOD to enumerate all devices attached to display adapter
  *
  */
-- 
1.8.3.4

