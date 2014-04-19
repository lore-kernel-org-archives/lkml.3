Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161013AbaDSAP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59156 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaDSAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:52 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 8/8] pci-stub: added spaces around equal sign
Date: Fri, 18 Apr 2014 20:13:53 -0400
Message-Id: <1397866433-21119-9-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message
  ERROR: spaces required around that '=' (ctx:VxV)
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci-stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index 2ff7750..886fb35 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -55,7 +55,7 @@ static int __init pci_stub_init(void)
 	p = ids;
 	while ((id = strsep(&p, ","))) {
 		unsigned int vendor, device, subvendor = PCI_ANY_ID,
-			subdevice = PCI_ANY_ID, class=0, class_mask=0;
+			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
 		int fields;
 
 		if (!strlen(id))
-- 
1.9.1

