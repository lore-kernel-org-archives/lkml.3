Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbbACMcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:32:07 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49606 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbACMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:32:02 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v2 2/5] Staging: comedi: fix line over 80 characters warning
Date: Sat,  3 Jan 2015 18:01:26 +0530
Message-Id: <1420288289-4477-3-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420288289-4477-1-git-send-email-jkhasdev@gmail.com>
References: <1420288289-4477-1-git-send-email-jkhasdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file pcl812.c that fix up warning line
over 80 character which is found by checkpatch tool.

Singed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 24eb601..069af70 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -519,7 +519,9 @@ struct pcl812_private {
 	unsigned int hwdmaptr[2];	/*  HW PTR to DMA buf */
 	unsigned int dmabytestomove[2];	/*  how many bytes DMA transfer */
 	int next_dma_buf;	/*  which buffer is next to use */
-	unsigned int dma_runs_to_end;	/*  how many times we must switch DMA buffers */
+	unsigned int dma_runs_to_end;	/*  how many times we must switch
+					 *  DMA buffers
+					 */
 	unsigned int last_dma_run;	/*  how many bytes to transfer on last DMA buffer */
 	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
 	unsigned int divisor1;
-- 
1.9.1

