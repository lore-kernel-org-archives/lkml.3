Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaDDSSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:18:48 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:43572 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaDDSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:18:47 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 2/2] pci: added space before the open parenthesis
Date: Fri,  4 Apr 2014 14:18:10 -0400
Message-Id: <1396635490-3630-1-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve checkpatch.pl error

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fdbc294..56acb63 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -114,7 +114,7 @@ unsigned char pci_bus_max_busnr(struct pci_bus* bus)
 	max = bus->busn_res.end;
 	list_for_each(tmp, &bus->children) {
 		n = pci_bus_max_busnr(pci_bus_b(tmp));
-		if(n > max)
+		if (n > max)
 			max = n;
 	}
 	return max;
-- 
1.9.1

