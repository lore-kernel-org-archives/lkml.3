Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaDSAP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54362 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaDSAOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:32 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 1/8] ats: removed parentheses after return
Date: Fri, 18 Apr 2014 20:13:46 -0400
Message-Id: <1397866433-21119-2-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
  ERROR: return is not a function, parentheses are not required
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/ats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index a8099d4..d653182 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -369,7 +369,7 @@ int pci_max_pasids(struct pci_dev *pdev)
 
 	supported = (supported & PASID_NUMBER_MASK) >> PASID_NUMBER_SHIFT;
 
-	return (1 << supported);
+	return 1 << supported;
 }
 EXPORT_SYMBOL_GPL(pci_max_pasids);
 #endif /* CONFIG_PCI_PASID */
-- 
1.9.1

