Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab3BQGzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:55:25 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53265 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3BQGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:55:23 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: addi-data: hwdrv_apci3200.c: Add a missing semicolon
Date: Sat, 16 Feb 2013 22:54:58 -0800
Message-Id: <1361084099-12776-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for missing end-of-statement by adding a semicolon

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 829af18..c790873 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -633,7 +633,7 @@ static int apci3200_do_insn_bits(struct comedi_device *dev,
 	s->state = inl(devpriv->i_IobaseAddon) & 0xf;
 	if (mask) {
 		s->state &= ~mask;
-		s->state |= (bits & mask)
+		s->state |= (bits & mask);
 
 		outl(s->state, devpriv->i_IobaseAddon);
 	}
-- 
1.7.9.5

