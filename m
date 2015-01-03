Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbbACMcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 07:32:14 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:63602 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbbACMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 07:32:11 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH v2 4/5] Staging: comedi: fix line over 80 characters warning
Date: Sat,  3 Jan 2015 18:01:28 +0530
Message-Id: <1420288289-4477-5-git-send-email-jkhasdev@gmail.com>
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
 drivers/staging/comedi/drivers/pcl812.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index aae934e7..5aeb695 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -525,7 +525,7 @@ struct pcl812_private {
 	unsigned int last_dma_run;	/*  how many bytes to transfer on last
 					 *  DMA buffer
 					 */
-	unsigned int max_812_ai_mode0_rangewait;	/*  setling time for gain */
+	unsigned int max_812_ai_mode0_rangewait; /*  setling time for gain */
 	unsigned int divisor1;
 	unsigned int divisor2;
 	unsigned int use_diff:1;
-- 
1.9.1

