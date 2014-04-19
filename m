Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaDSAPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:39 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51328 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaDSAOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:40 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 4/8] htirq: removed space after open parenthesis
Date: Fri, 18 Apr 2014 20:13:49 -0400
Message-Id: <1397866433-21119-5-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
  ERROR: space prohibited after that open parenthesis '('
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/htirq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 776c2ef..40862e6 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -105,7 +105,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 
 	max_irq = (data >> 16) & 0xff;
-	if ( idx > max_irq)
+	if (idx > max_irq)
 		return -EINVAL;
 
 	cfg = kmalloc(sizeof(*cfg), GFP_KERNEL);
-- 
1.9.1

