Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaL2JNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:13:25 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59184 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaL2JNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:13:24 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, sudipm.mukherjee@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH] Staging: comedi: drivers: fix space coding style issue in s626.c
Date: Mon, 29 Dec 2014 14:42:56 +0530
Message-Id: <1419844376-6660-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up a space error
found by the checkpatch.pl tool

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

