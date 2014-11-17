Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaKQWOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:14:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:17576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaKQWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:14:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417819793"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc] mei: txe: add cherrytrail device id
Date: Tue, 18 Nov 2014 00:13:21 +0200
Message-Id: <1416262401-26948-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-txe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/pci-txe.c b/drivers/misc/mei/pci-txe.c
index bee1c6fb7e75..1b1a6e558c1c 100644
--- a/drivers/misc/mei/pci-txe.c
+++ b/drivers/misc/mei/pci-txe.c
@@ -37,6 +37,7 @@
 
 static const struct pci_device_id mei_txe_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, 0x0F18)}, /* Baytrail */
+	{PCI_VDEVICE(INTEL, 0x2298)}, /* Cherrytrail */
 
 	{0, }
 };
-- 
1.9.3

