Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbbAIQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:36:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37676 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbAIQgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:36:48 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v5] Staging: comedi: fix line over 80 characters warning
Date: Fri,  9 Jan 2015 22:05:56 +0530
Message-Id: <1420821356-5724-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file pcl812.c that fix line over 80
characters warning which is found by checkpatch.pl tool.

Signed-off-by: Jitendra kumar khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index ac243ca..3eac017 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -507,20 +507,26 @@ static const struct pcl812_board boardtypes[] = {
 };
 
 struct pcl812_private {
-	unsigned char dma;	/*  >0 use dma ( usedDMA channel) */
+	unsigned char dma;		/*  >0 use dma ( usedDMA channel) */
 	unsigned char range_correction;	/*  =1 we must add 1 to range number */
 	unsigned int last_ai_chanspec;
-	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
+	unsigned char mode_reg_int;	/*  there is stored INT number for
+					 *  some card
+					 */
 	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
 	unsigned int dmapages;
 	unsigned int hwdmasize;
 	unsigned long dmabuf[2];	/*  PTR to DMA buf */
 	unsigned int hwdmaptr[2];	/*  HW PTR to DMA buf */
 	unsigned int dmabytestomove[2];	/*  how many bytes DMA transfer */
-	int next_dma_buf;	/*  which buffer is next to use */
-	unsigned int dma_runs_to_end;	/*  how many times we must switch DMA buffers */
-	unsigned int last_dma_run;	/*  how many bytes to transfer on last DMA buffer */
-	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
+	int next_dma_buf;		/*  which buffer is next to use */
+	unsigned int dma_runs_to_end;	/*  how many times we must switch
+					 *  DMA buffers
+					 */
+	unsigned int last_dma_run;	/*  how many bytes to transfer on
+					 *  last DMA buffer
+					 */
+	unsigned int max_812_ai_mode0_rangewait;    /* setling time for gain */
 	unsigned int divisor1;
 	unsigned int divisor2;
 	unsigned int use_diff:1;
@@ -1235,7 +1241,7 @@ static int pcl812_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		for (i = 0; i < 2; i++) {
 			unsigned long dmabuf;
 
-			dmabuf =  __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
+			dmabuf = __get_dma_pages(GFP_KERNEL, devpriv->dmapages);
 			if (!dmabuf)
 				return -ENOMEM;
 
-- 
1.9.1

