Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaL1S5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:57:14 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:35538 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaL1S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:56:41 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: [PATCH 2/3] comedi: checkpatch error/warning: spaces
Date: Sun, 28 Dec 2014 19:56:14 +0100
Message-Id: <1419792975-31519-3-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
References: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will fix the following checkpatch errors/warnings in
drivers/staging/comedi/ which are brought by wrong spacing:
	ERROR: trailing whitespace
	ERROR: space prohibited before that ',' (ctx:WxW)
	WARNING: please, no space before tabs

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 2 +-
 drivers/staging/comedi/drivers/das16m1.c      | 2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c  | 2 +-
 drivers/staging/comedi/drivers/ni_stc.h       | 4 ++--
 drivers/staging/comedi/drivers/s626.c         | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 4172e99..c8daa47 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -40,7 +40,7 @@ Configuration options: not applicable, uses PCI auto config
    for the card, and here are the findings so far.
 
    1. A good document that describes the PCI interface chip is 9080db-106.pdf
-      available from http://www.plxtech.com/products/io/pci9080 
+      available from http://www.plxtech.com/products/io/pci9080
 
    2. The initialization done so far is:
 	a. program the FPGA (windows code sans a lot of error messages)
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index 3895aa9..d8852c6 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -80,7 +80,7 @@ irq can be omitted, although the cmd interface will not work without it.
   89ab	8254
   cdef	8254
   400	8255
-  404-407 	8254
+  404-407	8254
 
 */
 
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 69e543a..bff4852 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -108,7 +108,7 @@ TRIG_WAKE_EOS
 #define   IRQ_LVL_BITS(x)		(((x) & 0xf) << 4)	/*  sets irq level */
 #define   FIFO_INTR_EN_BIT		0x100	/*  enable fifo interrupts */
 #define   FIFO_INTR_FHF_BIT		0x200	/*  interrupt fifo half full */
-#define   DMA_INTR_EN_BIT 		0x800	/*  enable interrupt on dma terminal count */
+#define   DMA_INTR_EN_BIT		0x800	/*  enable interrupt on dma terminal count */
 #define   DMA_DEM_EN_BIT	0x1000	/*  enables demand mode dma */
 #define I8253_BASE_REG		0x14
 #define I8253_MODE_REG		0x17
diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index bd69c3f..bb76fe1 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -166,7 +166,7 @@ enum Interrupt_B_Ack_Bits {
 #define AI_SCAN_IN_PROG_Pulse			_bit4
 #define AI_EXTMUX_CLK_Pulse			_bit3
 #define AI_LOCALMUX_CLK_Pulse			_bit2
-#define AI_SC_TC_Pulse			 	_bit1
+#define AI_SC_TC_Pulse				_bit1
 #define AI_CONVERT_Pulse			_bit0
 
 #define AO_Command_1_Register		9
@@ -642,7 +642,7 @@ static unsigned AO_UPDATE_Output_Select(enum ao_update_output_selection
 #define G_Load_Source_Select		_bit7
 #define G_Reload_Source_Switching	_bit15
 #define G_Loading_On_Gate		_bit14
-#define G_Gate_Polarity 		_bit13
+#define G_Gate_Polarity			_bit13
 
 #define G_Counting_Once(a)		(((a)&0x03)<<10)
 #define G_Stop_Mode(a)			(((a)&0x03)<<5)
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 14932c5..fc497dd 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -118,7 +118,7 @@ static void s626_mc_enable(struct comedi_device *dev,
 static void s626_mc_disable(struct comedi_device *dev,
 			    unsigned int cmd, unsigned int reg)
 {
-	writel(cmd << 16 , dev->mmio + reg);
+	writel(cmd << 16, dev->mmio + reg);
 	mmiowb();
 }
 
-- 
1.9.1

