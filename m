Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3ICUbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:31:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55342 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754095Ab3ICUbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:31:07 -0400
Message-ID: <1378240265.7347.24.camel@joe-AO722>
Subject: [PATCH] pci.h: Fix typo, remove unnecessary !!
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Sep 2013 13:31:05 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use normal kernel-doc "Returns:" instead of retruns
Assignment to bool is always 1 or 0 so the !! isn't necessary.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/pci.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index da172f9..ee0f3b6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1749,11 +1749,11 @@ static inline int pci_pcie_cap(struct pci_dev *dev)
  * pci_is_pcie - check if the PCI device is PCI Express capable
  * @dev: PCI device
  *
- * Retrun true if the PCI device is PCI Express capable, false otherwise.
+ * Returns: true if the PCI device is PCI Express capable, false otherwise.
  */
 static inline bool pci_is_pcie(struct pci_dev *dev)
 {
-	return !!pci_pcie_cap(dev);
+	return pci_pcie_cap(dev);
 }
 
 /**


