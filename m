Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaGBTk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:40:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40901 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaGBTk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:40:27 -0400
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Kumar Gaurav <kumargauravgupta3@gmail.com>
Subject: [PATCH] Block: rsxx: core: Removed depricated flag IRQF_DISABLED
Date: Thu,  3 Jul 2014 01:09:58 +0530
Message-Id: <1404329998-30640-1-git-send-email-kumargauravgupta3@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_DISABLED flag is depricated and should be removed.

Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
---
 drivers/block/rsxx/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2ee..ddb6b2b 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -886,7 +886,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 				"Failed to enable MSI\n");
 	}
 
-	st = request_irq(dev->irq, rsxx_isr, IRQF_DISABLED | IRQF_SHARED,
+	st = request_irq(dev->irq, rsxx_isr, IRQF_SHARED,
 			 DRIVER_NAME, card);
 	if (st) {
 		dev_err(CARD_TO_DEV(card),
-- 
1.7.9.5

