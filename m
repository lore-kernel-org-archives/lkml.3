Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbbAJEZC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 23:25:02 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58717 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbbAJEZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 23:25:00 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v6] Staging: comedi: patch to fix 80 characters line over warnings
Date: Sat, 10 Jan 2015 09:54:39 +0530
Message-Id: <1420863879-4066-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the patch to pcl812.c that fix 80 character line over warnings.
These warnings are identified by checkpatch.pl tool.
For this patch I have did following changes,
1. convert single line comment into multiline comment
2. provide tab sapce for indentation purpose
3. reduce extra space between ( = ) sign.

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

