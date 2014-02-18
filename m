Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaBRFbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:31:15 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:49576 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaBRFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:31:14 -0500
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 1/2] misc: add comment on unused minors
Date: Tue, 18 Feb 2014 02:27:24 -0300
Message-Id: <1392701245-4645-2-git-send-email-lucas.demarchi@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
References: <1392701245-4645-1-git-send-email-lucas.demarchi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.demarchi@intel.com>

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 include/linux/miscdevice.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 7bb6148..51e26f3 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -11,13 +11,13 @@
  */
 
 #define PSMOUSE_MINOR		1
-#define MS_BUSMOUSE_MINOR	2
-#define ATIXL_BUSMOUSE_MINOR	3
+#define MS_BUSMOUSE_MINOR	2	/* unused */
+#define ATIXL_BUSMOUSE_MINOR	3	/* unused */
 /*#define AMIGAMOUSE_MINOR	4	FIXME OBSOLETE */
-#define ATARIMOUSE_MINOR	5
-#define SUN_MOUSE_MINOR		6
-#define APOLLO_MOUSE_MINOR	7
-#define PC110PAD_MINOR		9
+#define ATARIMOUSE_MINOR	5	/* unused */
+#define SUN_MOUSE_MINOR		6	/* unused */
+#define APOLLO_MOUSE_MINOR	7	/* unused */
+#define PC110PAD_MINOR		9	/* unused */
 /*#define ADB_MOUSE_MINOR	10	FIXME OBSOLETE */
 #define WATCHDOG_MINOR		130	/* Watchdog timer     */
 #define TEMP_MINOR		131	/* Temperature Sensor */
@@ -25,10 +25,10 @@
 #define EFI_RTC_MINOR		136	/* EFI Time services */
 #define VHCI_MINOR		137
 #define SUN_OPENPROM_MINOR	139
-#define DMAPI_MINOR		140	/* DMAPI */
+#define DMAPI_MINOR		140	/* unused */
 #define NVRAM_MINOR		144
 #define SGI_MMTIMER		153
-#define STORE_QUEUE_MINOR	155
+#define STORE_QUEUE_MINOR	155	/* unused */
 #define I2O_MINOR		166
 #define MICROCODE_MINOR		184
 #define VFIO_MINOR		196
-- 
1.9.0

