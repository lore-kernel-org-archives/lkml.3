Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbbAEG1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:27:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46548 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbbAEG1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:27:31 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v4] Staging: comedi: Fix over 80 character line limit
Date: Mon,  5 Jan 2015 11:56:40 +0530
Message-Id: <1420439200-3537-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to pcl812.c that fix 80 character line limit which is found
by checkpatch.pl tool.
I have already sent this patch earlier but it was in 5 different patches,
this time I have make it into one patch.

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index ac243ca..fe9496a 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -510,7 +510,8 @@ struct pcl812_private {
 	unsigned char dma;	/*  >0 use dma ( usedDMA channel) */
 	unsigned char range_correction;	/*  =1 we must add 1 to range number */
 	unsigned int last_ai_chanspec;
-	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
+	unsigned char mode_reg_int;	/*  there is stored INT number for
+					 *  some card */
 	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
 	unsigned int dmapages;
 	unsigned int hwdmasize;
@@ -518,9 +519,11 @@ struct pcl812_private {
 	unsigned int hwdmaptr[2];	/*  HW PTR to DMA buf */
 	unsigned int dmabytestomove[2];	/*  how many bytes DMA transfer */
 	int next_dma_buf;	/*  which buffer is next to use */
-	unsigned int dma_runs_to_end;	/*  how many times we must switch DMA buffers */
-	unsigned int last_dma_run;	/*  how many bytes to transfer on last DMA buffer */
-	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
+	unsigned int dma_runs_to_end;	/*  how many times we must switch
+					 *  DMA buffers */
+	unsigned int last_dma_run;	/*  how many bytes to transfer on
+					 *  last DMA buffer */
+	unsigned int max_812_ai_mode0_rangewait;    /* setling time for gain */
 	unsigned int divisor1;
 	unsigned int divisor2;
 	unsigned int use_diff:1;
@@ -1235,7 +1238,7 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			unsigned long dmabuf;
 
-			dmabuf =  __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
+			dmabuf = __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
 			if (!dmabuf)
 				return -ENOMEM;
 
-- 
1.9.1

