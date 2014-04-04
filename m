Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaDDVZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:25:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41195 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaDDVZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:25:19 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH] pci: changed '...pci_bus* bus' to '...pci_bus *bus'
Date: Fri,  4 Apr 2014 17:23:34 -0400
Message-Id: <1396646614-6458-1-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
    drivers/pci/pci.c:109: ERROR: "foo* bar" should be "foo *bar"
branch: Linux 3.14-rc8

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fdbc294..a50d542 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -106,7 +106,7 @@ static bool pcie_ari_disabled;
  * Given a PCI bus, returns the highest PCI bus number present in the set
  * including the given PCI bus and its list of child PCI buses.
  */
-unsigned char pci_bus_max_busnr(struct pci_bus* bus)
+unsigned char pci_bus_max_busnr(struct pci_bus *bus)
 {
 	struct list_head *tmp;
 	unsigned char max, n;
-- 
1.9.1

