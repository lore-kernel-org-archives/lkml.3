Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaDSAPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:43 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56833 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaDSAOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:42 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 5/8] msi: merged quoted strings
Date: Fri, 18 Apr 2014 20:13:50 -0400
Message-Id: <1397866433-21119-6-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
  WARNING: quoted string split across lines
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/msi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 955ab79..31ae0bb 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -917,8 +917,7 @@ int pci_enable_msi_block(struct pci_dev *dev, int nvec)
 
 	/* Check whether driver already requested MSI-X irqs */
 	if (dev->msix_enabled) {
-		dev_info(&dev->dev, "can't enable MSI "
-			 "(MSI-X already enabled)\n");
+		dev_info(&dev->dev, "can't enable MSI (MSI-X already enabled)\n");
 		return -EINVAL;
 	}
 
@@ -1029,8 +1028,7 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 
 	/* Check whether driver already requested for MSI irq */
 	if (dev->msi_enabled) {
-		dev_info(&dev->dev, "can't enable MSI-X "
-		       "(MSI IRQ already assigned)\n");
+		dev_info(&dev->dev, "can't enable MSI-X (MSI IRQ already assigned)\n");
 		return -EINVAL;
 	}
 	status = msix_capability_init(dev, entries, nvec);
-- 
1.9.1

