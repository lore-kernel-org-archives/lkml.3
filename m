Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaL2J2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:28:12 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54863 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaL2J2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:28:09 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, chase.southwood@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: driver : fix max 80 character coding style issue in s626.c
Date: Mon, 29 Dec 2014 14:57:48 +0530
Message-Id: <1419845268-7833-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the s626.c file that fixes up a maximum 80 character limit
warning found by the checkpatch.pl tool

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/s626.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index fc497dd..77f715b 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
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

