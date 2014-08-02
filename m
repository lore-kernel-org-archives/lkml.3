Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbaHBWaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:30:09 -0400
Received: from s87.loopia.se ([194.9.94.112]:39225 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaHBWaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:30:07 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2014 18:30:07 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/1] cris: fix %d confusingly prefixed with 0x in format string
Date: Sat,  2 Aug 2014 15:20:43 -0700
Message-Id: <1407018043-648-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 arch/cris/arch-v32/drivers/cryptocop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index 877da19..0ae4f65 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -3155,7 +3155,7 @@ static void print_dma_descriptors(struct cryptocop_int_operation *iop)
 	printk("print_dma_descriptors start\n");
 
 	printk("iop:\n");
-	printk("\tsid: 0x%lld\n", iop->sid);
+	printk("\tsid: 0x%llx\n", iop->sid);
 
 	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
 	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);
-- 
2.0.0.526.g5318336

