Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbbAJFki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:40:38 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:63357 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbAJFgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:47 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 12/25] staging: line6: List out capabilities individually
Date: Fri,  9 Jan 2015 23:35:58 -0600
Message-Id: <1420868171-2031-13-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `LINE6_CAP_CTRL_PCM_HW' macro combines three capabilities to save
horizontal space when defining the properties entries.  Now that these
are no longer limited to single lines this is not such a concern.
Specify capabilities individually when defining each property for
better clarity.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c  | 54 +++++++++++++++++++++++++++--------------
 drivers/staging/line6/usbdefs.h |  4 ---
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index c988b78..6fecc1b 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -61,92 +61,110 @@ static const struct line6_properties line6_properties_table[] = {
 	[LINE6_BASSPODXT] = {
 		.id = "BassPODxt",
 		.name = "BassPODxt",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_BASSPODXTLIVE] = {
 		.id = "BassPODxtLive",
 		.name = "BassPODxt Live",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_BASSPODXTPRO] = {
 		.id = "BassPODxtPro",
 		.name = "BassPODxt Pro",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_GUITARPORT] = {
 		.id = "GuitarPort",
 		.name = "GuitarPort",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_POCKETPOD] = {
 		.id = "PocketPOD",
 		.name = "Pocket POD",
-		.capabilities = LINE6_CAP_CONTROL,
+		.capabilities	= LINE6_CAP_CONTROL,
 	},
 	[LINE6_PODHD300] = {
 		.id = "PODHD300",
 		.name = "POD HD300",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_PODHD400] = {
 		.id = "PODHD400",
 		.name = "POD HD400",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_PODHD500] = {
 		.id = "PODHD500",
 		.name = "POD HD500",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_PODSTUDIO_GX] = {
 		.id = "PODStudioGX",
 		.name = "POD Studio GX",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_PODSTUDIO_UX1] = {
 		.id = "PODStudioUX1",
 		.name = "POD Studio UX1",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_PODSTUDIO_UX2] = {
 		.id = "PODStudioUX2",
 		.name = "POD Studio UX2",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_PODXT] = {
 		.id = "PODxt",
 		.name = "PODxt",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_PODXTLIVE] = {
 		.id = "PODxtLive",
 		.name = "PODxt Live",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_PODXTPRO] = {
 		.id = "PODxtPro",
 		.name = "PODxt Pro",
-		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+		.capabilities	= LINE6_CAP_CONTROL
+				| LINE6_CAP_PCM
+				| LINE6_CAP_HWMON,
 	},
 	[LINE6_TONEPORT_GX] = {
 		.id = "TonePortGX",
 		.name = "TonePort GX",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_TONEPORT_UX1] = {
 		.id = "TonePortUX1",
 		.name = "TonePort UX1",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_TONEPORT_UX2] = {
 		.id = "TonePortUX2",
 		.name = "TonePort UX2",
-		.capabilities = LINE6_CAP_PCM,
+		.capabilities	= LINE6_CAP_PCM,
 	},
 	[LINE6_VARIAX] = {
 		.id = "Variax",
 		.name = "Variax Workbench",
-		.capabilities = LINE6_CAP_CONTROL,
+		.capabilities	= LINE6_CAP_CONTROL,
 	}
 };
 
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index d6e46ee..f4d080e 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -21,10 +21,6 @@
 /* device support hardware monitoring */
 #define LINE6_CAP_HWMON (1 << 2)
 
-#define LINE6_CAP_CTRL_PCM_HW	(LINE6_CAP_CONTROL |	\
-					 LINE6_CAP_PCM |	\
-					 LINE6_CAP_HWMON)
-
 #define LINE6_FALLBACK_INTERVAL 10
 #define LINE6_FALLBACK_MAXPACKETSIZE 16
 
-- 
2.1.0

