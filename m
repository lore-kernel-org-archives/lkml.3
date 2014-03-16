Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaCPMVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:21:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38678 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCPMVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:21:21 -0400
Date: Sun, 16 Mar 2014 13:20:16 +0100
From: Davide Berardi <berardi.dav@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fixing some coding style issues on line6 driver.c
Message-ID: <20140316132016.388a3f69@White-Rabbit>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some over-80 characters lines.
(this is for eudyptula challenge task 10).

From: Davide Berardi <berardi.dav@gmail.com>

Signed-off-by: Davide Berardi <berardi.dav@gmail.com>
---
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index e7a9d8d..b3652e6 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -59,26 +59,46 @@ MODULE_DEVICE_TABLE(usb, line6_id_table);
 
 /* *INDENT-OFF* */
 static struct line6_properties line6_properties_table[] = {
-	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
-	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
-	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3,         "PODX3",         "POD X3",           LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",     "POD X3 Live",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODXT,         "PODxt",         "PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",     "PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTPRO,      "PODxtPro",      "PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",    "TonePort GX",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_VARIAX,        "Variax",        "Variax Workbench", LINE6_BIT_CONTROL           },
+	{ LINE6_BIT_BASSPODXT,     "BassPODxt",
+		"BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive",
+		"BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",
+		"BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_GUITARPORT,    "GuitarPort",
+		"GuitarPort",       LINE6_BIT_PCM               },
+	{ LINE6_BIT_POCKETPOD,     "PocketPOD",
+		"Pocket POD",       LINE6_BIT_CONTROL           },
+	{ LINE6_BIT_PODHD300,      "PODHD300",
+		"POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD400,      "PODHD400",
+		"POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODHD500,      "PODHD500",
+		"POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",
+		"POD Studio GX",    LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",
+		"POD Studio UX1",   LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",
+		"POD Studio UX2",   LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODX3,         "PODX3",
+		"POD X3",           LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",
+		"POD X3 Live",      LINE6_BIT_PCM               },
+	{ LINE6_BIT_PODXT,         "PODxt",
+		"PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",
+		"PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_PODXTPRO,      "PODxtPro",
+		"PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
+	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",
+		"TonePort GX",      LINE6_BIT_PCM               },
+	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",
+		"TonePort UX1",     LINE6_BIT_PCM               },
+	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",
+		"TonePort UX2",     LINE6_BIT_PCM               },
+	{ LINE6_BIT_VARIAX,        "Variax",
+		"Variax Workbench", LINE6_BIT_CONTROL           },
 };
 /* *INDENT-ON* */
 
@@ -152,10 +172,10 @@ int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
 		int retval;
 
 		retval = usb_interrupt_msg(line6->usbdev,
-					   usb_sndintpipe(line6->usbdev,
-							  line6->ep_control_write),
-					   (char *)frag_buf, frag_size,
-					   &partial, LINE6_TIMEOUT * HZ);
+					usb_sndintpipe(line6->usbdev,
+						line6->ep_control_write),
+					(char *)frag_buf, frag_size,
+					&partial, LINE6_TIMEOUT * HZ);
 
 		if (retval) {
 			dev_err(line6->ifcdev,
