Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbbACIh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 03:37:28 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42115 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbACIhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 03:37:16 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 1/5] Staging: comedi: fix line over 80 characters warning
Date: Sat,  3 Jan 2015 14:06:23 +0530
Message-Id: <1420274187-6779-2-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
References: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file pcl812.c that fix up warning line
over 80 character which is found by checkpatch tool.

Singed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/pcl812.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index ac243ca..24eb601 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -510,7 +510,8 @@ struct pcl812_private {
 	unsigned char dma;	/*  >0 use dma ( usedDMA channel) */
 	unsigned char range_correction;	/*  =1 we must add 1 to range number */
 	unsigned int last_ai_chanspec;
-	unsigned char mode_reg_int;	/*  there is stored INT number for some card */
+	unsigned char mode_reg_int;	/*  there is stored INT number
+					    for some card */
 	unsigned int ai_poll_ptr;	/*  how many sampes transfer poll */
 	unsigned int dmapages;
 	unsigned int hwdmasize;
-- 
1.9.1

