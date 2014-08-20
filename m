Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaHTQku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:40:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46248 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHTQks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:40:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen-pciback: Add MODULE_ALIAS for pciback.
Date: Wed, 20 Aug 2014 12:40:38 -0400
Message-Id: <1408552838-4032-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
References: <1408552838-4032-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rest of the Xen device drivers use an module alias
to load devices when they shop up in XenBus.

This is done for the rest of them but hadn't been done
for Xen PCI back. This patch fixes it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d57a173..7da75f7 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1538,3 +1538,4 @@ module_exit(xen_pcibk_cleanup);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("xen-backend:pci");
+MODULE_ALIAS("xen:pci");
-- 
1.9.3

