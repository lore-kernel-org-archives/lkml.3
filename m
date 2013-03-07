Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3CGOs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:48:59 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36814 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab3CGOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:48:58 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: comedi: Fix typo in comedi
Date: Thu,  7 Mar 2013 23:48:40 +0900
Message-Id: <1362667720-16612-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.2.rc1.19.g443d803
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typos in staging/comedi

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c | 4 ++--
 drivers/staging/comedi/drivers/adv_pci1710.c            | 4 ++--
 drivers/staging/comedi/drivers/cb_pcidas64.c            | 2 +-
 drivers/staging/comedi/drivers/icp_multi.c              | 2 +-
 drivers/staging/comedi/drivers/me_daq.c                 | 2 +-
 drivers/staging/comedi/drivers/pcl816.c                 | 2 +-
 drivers/staging/comedi/drivers/usbdux.c                 | 2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c            | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
index 1e05732..97e7eec 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
@@ -704,9 +704,9 @@ static int i_APCI1710_InsnReadSSIValue(struct comedi_device *dev,
 |                                        unsigned char *_   pb_ChannelStatus)          |
 +----------------------------------------------------------------------------+
 | Task              :
-					(0) Set the digital output from selected SSI moule         |
+					(0) Set the digital output from selected SSI module         |
 |                     (b_ModuleNbr) ON
-                    (1) Set the digital output from selected SSI moule         |
+                    (1) Set the digital output from selected SSI module         |
 |                     (b_ModuleNbr) OFF
 					(2)Read the status from selected SSI digital input        |
 |                     (b_InputChannel)
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 3d788c7..b89643b 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -307,7 +307,7 @@ struct pci1710_private {
 	unsigned int ai_et_CntrlReg;
 	unsigned int ai_et_MuxVal;
 	unsigned int ai_et_div1, ai_et_div2;
-	unsigned int act_chanlist[32];	/*  list of scaned channel */
+	unsigned int act_chanlist[32];	/*  list of scanned channel */
 	unsigned char act_chanlist_len;	/*  len of scanlist */
 	unsigned char act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned char da_ranges;	/*  copy of D/A outpit range register */
@@ -334,7 +334,7 @@ static const unsigned int muxonechan[] = {
 
 /*
 ==============================================================================
- Check if channel list from user is builded correctly
+ Check if channel list from user is built correctly
  If it's ok, then program scan/gain logic.
  This works for all cards.
 */
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 9f3112c..a6f907a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1523,7 +1523,7 @@ static int alloc_and_init_dma_members(struct comedi_device *dev)
 	struct pcidas64_private *devpriv = dev->private;
 	int i;
 
-	/*  alocate pci dma buffers */
+	/*  allocate pci dma buffers */
 	for (i = 0; i < ai_dma_ring_count(thisboard); i++) {
 		devpriv->ai_buffer[i] =
 			pci_alloc_consistent(pcidev, DMA_BUFFER_SIZE,
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 1e08f91..34ff59f 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -120,7 +120,7 @@ struct icp_multi_private {
 	unsigned int DacCmdStatus;	/*  DAC Command/Status register */
 	unsigned int IntEnable;	/*  Interrupt Enable register */
 	unsigned int IntStatus;	/*  Interrupt Status register */
-	unsigned int act_chanlist[32];	/*  list of scaned channel */
+	unsigned int act_chanlist[32];	/*  list of scanned channel */
 	unsigned char act_chanlist_len;	/*  len of scanlist */
 	unsigned char act_chanlist_pos;	/*  actual position in MUX list */
 	unsigned int *ai_chanlist;	/*  actaul chanlist */
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index 06490eb..012ed72 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -426,7 +426,7 @@ static int me2600_xilinx_download(struct comedi_device *dev,
 
 	/*
 	 * Loop for writing firmware byte by byte to xilinx
-	 * Firmware data start at offfset 16
+	 * Firmware data start at offset 16
 	 */
 	for (i = 0; i < file_length; i++)
 		writeb((data[16 + i] & 0xff),
diff --git a/drivers/staging/comedi/drivers/pcl816.c b/drivers/staging/comedi/drivers/pcl816.c
index f625fda..ebd9e47 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -837,7 +837,7 @@ start_pacer(struct comedi_device *dev, int mode, unsigned int divisor1,
 
 /*
 ==============================================================================
- Check if channel list from user is builded correctly
+ Check if channel list from user is built correctly
  If it's ok, then return non-zero length of repeated segment of channel list
 */
 static int
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 1a0062a..6f2e429 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -56,7 +56,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
  *       functions firmware upload is by fxload and no longer by comedi (due to
  *       enumeration)
  * 0.97: USB IDs received, adjusted table
- * 0.98: SMP, locking, memroy alloc: moved all usb memory alloc
+ * 0.98: SMP, locking, memory alloc: moved all usb memory alloc
  *       to the usb subsystem and moved all comedi related memory
  *       alloc to comedi.
  *       | kernel | registration | usbdux-usb | usbdux-comedi | comedi |
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index d066351..cfbfeeb 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1369,7 +1369,7 @@ static int usbdux_getstatusinfo(struct comedi_device *dev, int chan)
 
 	/* 32 bits big endian from the A/D converter */
 	one = be32_to_cpu(*((int32_t *)((this_usbduxsub->insnBuffer)+1)));
-	/* mask out the staus byte */
+	/* mask out the status byte */
 	one = one & 0x00ffffff;
 	one = one ^ 0x00800000;
 
-- 
1.8.2.rc1.19.g443d803

