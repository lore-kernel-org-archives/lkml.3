Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaEKGPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 02:15:35 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45764 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaEKGPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 02:15:33 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v3 1/5] drivers: staging: ft1000: Fix indentation
Date: Sun, 11 May 2014 21:14:26 +0300
Message-Id: <1399832070-15276-2-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399832070-15276-1-git-send-email-wwctrsrx@gmail.com>
References: <1399832070-15276-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes indentation in header files.

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h |   92 +++++++++++-----------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
index 419e534..ad4bf8a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
@@ -23,62 +23,62 @@
 * History:
 * 11/5/02    Whc                Created.
 *
-*---------------------------------------------------------------------------//---------------------------------------------------------------------------
+*---------------------------------------------------------------------------
 */
 #ifndef _FT1000IOCTLH_
 #define _FT1000IOCTLH_
 
 typedef struct _IOCTL_GET_VER {
-    unsigned long drv_ver;
+	unsigned long drv_ver;
 } __packed IOCTL_GET_VER, *PIOCTL_GET_VER;
 
 /* Data structure for Dsp statistics */
 typedef struct _IOCTL_GET_DSP_STAT {
-    unsigned char DspVer[DSPVERSZ];        /* DSP version number */
-    unsigned char HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
-    unsigned char Sku[SKUSZ];              /* SKU */
-    unsigned char eui64[EUISZ];            /* EUI64 */
-    unsigned short ConStat;                /* Connection Status */
-                                /*    Bits 0-3 = Connection Status Field */
-                                /*               0000=Idle (Disconnect) */
-                                /*               0001=Searching */
-                                /*               0010=Active (Connected) */
-                                /*               0011=Waiting for L2 down */
-                                /*               0100=Sleep */
-    unsigned short LedStat;                /* Led Status */
-                                /*    Bits 0-3   = Signal Strength Field */
-                                /*                 0000 = -105dBm to -92dBm */
-                                /*                 0001 = -92dBm to -85dBm */
-                                /*                 0011 = -85dBm to -75dBm */
-                                /*                 0111 = -75dBm to -50dBm */
-                                /*                 1111 = -50dBm to 0dBm */
-                                /*    Bits 4-7   = Reserved */
-                                /*    Bits 8-11  = SNR Field */
-                                /*                 0000 = <2dB */
-                                /*                 0001 = 2dB to 8dB */
-                                /*                 0011 = 8dB to 15dB */
-                                /*                 0111 = 15dB to 22dB */
-                                /*                 1111 = >22dB */
-                                /*    Bits 12-15 = Reserved */
-    unsigned long nTxPkts;                /* Number of packets transmitted from host to dsp */
-    unsigned long nRxPkts;                /* Number of packets received from dsp to host */
-    unsigned long nTxBytes;               /* Number of bytes transmitted from host to dsp */
-    unsigned long nRxBytes;               /* Number of bytes received from dsp to host */
-    unsigned long ConTm;                  /* Current session connection time in seconds */
-    unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration Version */
-    unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
+	unsigned char DspVer[DSPVERSZ];        /* DSP version number */
+	unsigned char HwSerNum[HWSERNUMSZ];    /* Hardware Serial Number */
+	unsigned char Sku[SKUSZ];              /* SKU */
+	unsigned char eui64[EUISZ];            /* EUI64 */
+	unsigned short ConStat;                /* Connection Status */
+	/*    Bits 0-3 = Connection Status Field */
+	/*               0000=Idle (Disconnect) */
+	/*               0001=Searching */
+	/*               0010=Active (Connected) */
+	/*               0011=Waiting for L2 down */
+	/*               0100=Sleep */
+	unsigned short LedStat;                /* Led Status */
+	/*    Bits 0-3   = Signal Strength Field */
+	/*                 0000 = -105dBm to -92dBm */
+	/*                 0001 = -92dBm to -85dBm */
+	/*                 0011 = -85dBm to -75dBm */
+	/*                 0111 = -75dBm to -50dBm */
+	/*                 1111 = -50dBm to 0dBm */
+	/*    Bits 4-7   = Reserved */
+	/*    Bits 8-11  = SNR Field */
+	/*                 0000 = <2dB */
+	/*                 0001 = 2dB to 8dB */
+	/*                 0011 = 8dB to 15dB */
+	/*                 0111 = 15dB to 22dB */
+	/*                 1111 = >22dB */
+	/*    Bits 12-15 = Reserved */
+	unsigned long nTxPkts;                /* Number of packets transmitted from host to dsp */
+	unsigned long nRxPkts;                /* Number of packets received from dsp to host */
+	unsigned long nTxBytes;               /* Number of bytes transmitted from host to dsp */
+	unsigned long nRxBytes;               /* Number of bytes received from dsp to host */
+	unsigned long ConTm;                  /* Current session connection time in seconds */
+	unsigned char CalVer[CALVERSZ];       /* Proprietary Calibration Version */
+	unsigned char CalDate[CALDATESZ];     /* Proprietary Calibration Date */
 } __packed IOCTL_GET_DSP_STAT, *PIOCTL_GET_DSP_STAT;
 
 /* Data structure for Dual Ported RAM messaging between Host and Dsp */
 typedef struct _IOCTL_DPRAM_BLK {
-    unsigned short total_len;
+	unsigned short total_len;
 	struct pseudo_hdr pseudohdr;
-    unsigned char buffer[1780];
+	unsigned char buffer[1780];
 } __packed IOCTL_DPRAM_BLK, *PIOCTL_DPRAM_BLK;
 
 typedef struct _IOCTL_DPRAM_COMMAND {
-    unsigned short extra;
-    IOCTL_DPRAM_BLK dpram_blk;
+	unsigned short extra;
+	IOCTL_DPRAM_BLK dpram_blk;
 } __packed IOCTL_DPRAM_COMMAND, *PIOCTL_DPRAM_COMMAND;
 
 /*
@@ -86,13 +86,13 @@ typedef struct _IOCTL_DPRAM_COMMAND {
 */
 #define FT1000_MAGIC_CODE      'F'
 
-#define IOCTL_REGISTER_CMD					0
-#define IOCTL_SET_DPRAM_CMD					3
-#define IOCTL_GET_DPRAM_CMD					4
-#define IOCTL_GET_DSP_STAT_CMD      6
-#define IOCTL_GET_VER_CMD           7
-#define IOCTL_CONNECT               10
-#define IOCTL_DISCONNECT            11
+#define IOCTL_REGISTER_CMD	0
+#define IOCTL_SET_DPRAM_CMD	3
+#define IOCTL_GET_DPRAM_CMD	4
+#define IOCTL_GET_DSP_STAT_CMD	6
+#define IOCTL_GET_VER_CMD	7
+#define IOCTL_CONNECT		10
+#define IOCTL_DISCONNECT	11
 
 #define IOCTL_FT1000_GET_DSP_STAT _IOR(FT1000_MAGIC_CODE, IOCTL_GET_DSP_STAT_CMD, sizeof(IOCTL_GET_DSP_STAT)
 #define IOCTL_FT1000_GET_VER _IOR(FT1000_MAGIC_CODE, IOCTL_GET_VER_CMD, sizeof(IOCTL_GET_VER)
-- 
1.7.10.4

