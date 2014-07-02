Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaGBE65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:58:57 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:61768 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaGBE6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:58:53 -0400
From: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
To: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>,
        <alsa-devel@alsa-project.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-sound@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ice1712: Aligning definitions in header file
Date: Tue,  1 Jul 2014 23:58:45 -0500
Message-Id: <1404277125-10064-1-git-send-email-kostaslinuxxx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aligning #defines in ice1712.h file.

Signed-off-by: Konstantinos Tsimpoukas <kostaslinuxxx@gmail.com>
---
 sound/pci/ice1712/ice1712.h | 84 ++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/sound/pci/ice1712/ice1712.h b/sound/pci/ice1712/ice1712.h
index b209fc3..f88800a 100644
--- a/sound/pci/ice1712/ice1712.h
+++ b/sound/pci/ice1712/ice1712.h
@@ -41,18 +41,18 @@
 #define ICEREG(ice, x) ((ice)->port + ICE1712_REG_##x)
 
 #define ICE1712_REG_CONTROL		0x00	/* byte */
-#define   ICE1712_RESET			0x80	/* reset whole chip */
-#define   ICE1712_SERR_LEVEL		0x04	/* SERR# level otherwise edge */
-#define   ICE1712_NATIVE		0x01	/* native mode otherwise SB */
+#define ICE1712_RESET			0x80	/* reset whole chip */
+#define ICE1712_SERR_LEVEL		0x04	/* SERR# level otherwise edge */
+#define ICE1712_NATIVE			0x01	/* native mode otherwise SB */
 #define ICE1712_REG_IRQMASK		0x01	/* byte */
-#define   ICE1712_IRQ_MPU1		0x80
-#define   ICE1712_IRQ_TIMER		0x40
-#define   ICE1712_IRQ_MPU2		0x20
-#define   ICE1712_IRQ_PROPCM		0x10
-#define   ICE1712_IRQ_FM		0x08	/* FM/MIDI - legacy */
-#define   ICE1712_IRQ_PBKDS		0x04	/* playback DS channels */
-#define   ICE1712_IRQ_CONCAP		0x02	/* consumer capture */
-#define   ICE1712_IRQ_CONPBK		0x01	/* consumer playback */
+#define ICE1712_IRQ_MPU1		0x80
+#define ICE1712_IRQ_TIMER		0x40
+#define ICE1712_IRQ_MPU2		0x20
+#define ICE1712_IRQ_PROPCM		0x10
+#define ICE1712_IRQ_FM			0x08	/* FM/MIDI - legacy */
+#define ICE1712_IRQ_PBKDS		0x04	/* playback DS channels */
+#define ICE1712_IRQ_CONCAP		0x02	/* consumer capture */
+#define ICE1712_IRQ_CONPBK		0x01	/* consumer playback */
 #define ICE1712_REG_IRQSTAT		0x02	/* byte */
 /* look to ICE1712_IRQ_* */
 #define ICE1712_REG_INDEX		0x03	/* byte - indirect CCIxx regs */
@@ -62,23 +62,23 @@
 #define ICE1712_REG_NMI_INDEX		0x07	/* byte */
 #define ICE1712_REG_AC97_INDEX		0x08	/* byte */
 #define ICE1712_REG_AC97_CMD		0x09	/* byte */
-#define   ICE1712_AC97_COLD		0x80	/* cold reset */
-#define   ICE1712_AC97_WARM		0x40	/* warm reset */
-#define   ICE1712_AC97_WRITE		0x20	/* W: write, R: write in progress */
-#define   ICE1712_AC97_READ		0x10	/* W: read, R: read in progress */
-#define   ICE1712_AC97_READY		0x08	/* codec ready status bit */
-#define   ICE1712_AC97_PBK_VSR		0x02	/* playback VSR */
-#define   ICE1712_AC97_CAP_VSR		0x01	/* capture VSR */
+#define ICE1712_AC97_COLD		0x80	/* cold reset */
+#define ICE1712_AC97_WARM		0x40	/* warm reset */
+#define ICE1712_AC97_WRITE		0x20	/* W: write, R: write in progress */
+#define ICE1712_AC97_READ		0x10	/* W: read, R: read in progress */
+#define ICE1712_AC97_READY		0x08	/* codec ready status bit */
+#define ICE1712_AC97_PBK_VSR		0x02	/* playback VSR */
+#define ICE1712_AC97_CAP_VSR		0x01	/* capture VSR */
 #define ICE1712_REG_AC97_DATA		0x0a	/* word (little endian) */
 #define ICE1712_REG_MPU1_CTRL		0x0c	/* byte */
 #define ICE1712_REG_MPU1_DATA		0x0d	/* byte */
 #define ICE1712_REG_I2C_DEV_ADDR	0x10	/* byte */
-#define   ICE1712_I2C_WRITE		0x01	/* write direction */
+#define ICE1712_I2C_WRITE		0x01	/* write direction */
 #define ICE1712_REG_I2C_BYTE_ADDR	0x11	/* byte */
 #define ICE1712_REG_I2C_DATA		0x12	/* byte */
 #define ICE1712_REG_I2C_CTRL		0x13	/* byte */
-#define   ICE1712_I2C_EEPROM		0x80	/* EEPROM exists */
-#define   ICE1712_I2C_BUSY		0x01	/* busy bit */
+#define ICE1712_I2C_EEPROM		0x80	/* EEPROM exists */
+#define ICE1712_I2C_BUSY		0x01	/* busy bit */
 #define ICE1712_REG_CONCAP_ADDR		0x14	/* dword - consumer capture */
 #define ICE1712_REG_CONCAP_COUNT	0x18	/* word - current/base count */
 #define ICE1712_REG_SERR_SHADOW		0x1b	/* byte */
@@ -128,14 +128,14 @@
 #define ICE1712_DSC_ADDR1		0x02	/* dword - base address 1 */
 #define ICE1712_DSC_COUNT1		0x03	/* word - count 1 */
 #define ICE1712_DSC_CONTROL		0x04	/* byte - control & status */
-#define   ICE1712_BUFFER1		0x80	/* buffer1 is active */
-#define   ICE1712_BUFFER1_AUTO		0x40	/* buffer1 auto init */
-#define   ICE1712_BUFFER0_AUTO		0x20	/* buffer0 auto init */
-#define   ICE1712_FLUSH			0x10	/* flush FIFO */
-#define   ICE1712_STEREO		0x08	/* stereo */
-#define   ICE1712_16BIT			0x04	/* 16-bit data */
-#define   ICE1712_PAUSE			0x02	/* pause */
-#define   ICE1712_START			0x01	/* start */
+#define ICE1712_BUFFER1			0x80	/* buffer1 is active */
+#define ICE1712_BUFFER1_AUTO		0x40	/* buffer1 auto init */
+#define ICE1712_BUFFER0_AUTO		0x20	/* buffer0 auto init */
+#define ICE1712_FLUSH			0x10	/* flush FIFO */
+#define ICE1712_STEREO			0x08	/* stereo */
+#define ICE1712_16BIT			0x04	/* 16-bit data */
+#define ICE1712_PAUSE			0x02	/* pause */
+#define ICE1712_START			0x01	/* start */
 #define ICE1712_DSC_RATE		0x05	/* dword - rate */
 #define ICE1712_DSC_VOLUME		0x06	/* word - volume control */
 
@@ -146,12 +146,12 @@
 #define ICEMT(ice, x) ((ice)->profi_port + ICE1712_MT_##x)
 
 #define ICE1712_MT_IRQ			0x00	/* byte - interrupt mask */
-#define   ICE1712_MULTI_CAPTURE		0x80	/* capture IRQ */
-#define   ICE1712_MULTI_PLAYBACK	0x40	/* playback IRQ */
-#define   ICE1712_MULTI_CAPSTATUS	0x02	/* capture IRQ status */
-#define   ICE1712_MULTI_PBKSTATUS	0x01	/* playback IRQ status */
+#define ICE1712_MULTI_CAPTURE		0x80	/* capture IRQ */
+#define ICE1712_MULTI_PLAYBACK		0x40	/* playback IRQ */
+#define ICE1712_MULTI_CAPSTATUS		0x02	/* capture IRQ status */
+#define ICE1712_MULTI_PBKSTATUS		0x01	/* playback IRQ status */
 #define ICE1712_MT_RATE			0x01	/* byte - sampling rate select */
-#define   ICE1712_SPDIF_MASTER		0x10	/* S/PDIF input is master clock */
+#define ICE1712_SPDIF_MASTER		0x10	/* S/PDIF input is master clock */
 #define ICE1712_MT_I2S_FORMAT		0x02	/* byte - I2S data format */
 #define ICE1712_MT_AC97_INDEX		0x04	/* byte - AC'97 index */
 #define ICE1712_MT_AC97_CMD		0x05	/* byte - AC'97 command & status */
@@ -161,14 +161,14 @@
 #define ICE1712_MT_PLAYBACK_SIZE	0x14	/* word - playback size */
 #define ICE1712_MT_PLAYBACK_COUNT	0x16	/* word - playback count */
 #define ICE1712_MT_PLAYBACK_CONTROL	0x18	/* byte - control */
-#define   ICE1712_CAPTURE_START_SHADOW	0x04	/* capture start */
-#define   ICE1712_PLAYBACK_PAUSE	0x02	/* playback pause */
-#define   ICE1712_PLAYBACK_START	0x01	/* playback start */
+#define ICE1712_CAPTURE_START_SHADOW	0x04	/* capture start */
+#define ICE1712_PLAYBACK_PAUSE		0x02	/* playback pause */
+#define ICE1712_PLAYBACK_START		0x01	/* playback start */
 #define ICE1712_MT_CAPTURE_ADDR		0x20	/* dword - capture address */
 #define ICE1712_MT_CAPTURE_SIZE		0x24	/* word - capture size */
 #define ICE1712_MT_CAPTURE_COUNT	0x26	/* word - capture count */
 #define ICE1712_MT_CAPTURE_CONTROL	0x28	/* byte - control */
-#define   ICE1712_CAPTURE_START		0x01	/* capture start */
+#define ICE1712_CAPTURE_START		0x01	/* capture start */
 #define ICE1712_MT_ROUTE_PSDOUT03	0x30	/* word */
 #define ICE1712_MT_ROUTE_SPDOUT		0x32	/* word */
 #define ICE1712_MT_ROUTE_CAPTURE	0x34	/* dword */
@@ -176,7 +176,7 @@
 #define ICE1712_MT_MONITOR_INDEX	0x3a	/* byte */
 #define ICE1712_MT_MONITOR_RATE		0x3b	/* byte */
 #define ICE1712_MT_MONITOR_ROUTECTRL	0x3c	/* byte */
-#define   ICE1712_ROUTE_AC97		0x01	/* route digital mixer output to AC'97 */
+#define ICE1712_ROUTE_AC97		0x01	/* route digital mixer output to AC'97 */
 #define ICE1712_MT_MONITOR_PEAKINDEX	0x3e	/* byte */
 #define ICE1712_MT_MONITOR_PEAKDATA	0x3f	/* byte */
 
@@ -186,9 +186,9 @@
 
 /* PCI[60] System Configuration */
 #define ICE1712_CFG_CLOCK	0xc0
-#define   ICE1712_CFG_CLOCK512	0x00	/* 22.5692Mhz, 44.1kHz*512 */
-#define   ICE1712_CFG_CLOCK384  0x40	/* 16.9344Mhz, 44.1kHz*384 */
-#define   ICE1712_CFG_EXT	0x80	/* external clock */
+#define ICE1712_CFG_CLOCK512	0x00	/* 22.5692Mhz, 44.1kHz*512 */
+#define ICE1712_CFG_CLOCK384    0x40	/* 16.9344Mhz, 44.1kHz*384 */
+#define ICE1712_CFG_EXT		0x80	/* external clock */
 #define ICE1712_CFG_2xMPU401	0x20	/* two MPU401 UARTs */
 #define ICE1712_CFG_NO_CON_AC97 0x10	/* consumer AC'97 codec is not present */
 #define ICE1712_CFG_ADC_MASK	0x0c	/* one, two, three, four stereo ADCs */
-- 
1.9.1

