Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaL1VpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 16:45:12 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40658 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaL1VpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 16:45:07 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, pankaj.saraf@nektech.in,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix space and 80 char coding style issue
Date: Mon, 29 Dec 2014 03:14:45 +0530
Message-Id: <1419803085-9441-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up spcae and maximum
character limit warning found by the checkpatch.pl tool

Signed-off-by: Jitendra Kumar Khasdev  <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 14932c5..77f715b 100644
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
 
@@ -2534,7 +2534,8 @@ static int s626_initialize(struct comedi_device *dev)
 	for (i = 0; i < 2; i++) {
 		writel(S626_I2C_CLKSEL, dev->mmio + S626_P_I2CSTAT);
 		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
+		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc,
+		0);
 		if (ret)
 			return ret;
 	}
-- 
1.9.1

