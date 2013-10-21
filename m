Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3JUTP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:1334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3JUTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681979"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 7/8] mei: replace stray pr_debug with dev_dbg
Date: Mon, 21 Oct 2013 22:05:42 +0300
Message-Id: <1382382343-12066-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Driver better use dev_dbg, not pr_debug.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1bf300e..b96205a 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -190,7 +190,7 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	schedule_delayed_work(&dev->timer_work, HZ);
 
-	pr_debug("initialization successful.\n");
+	dev_dbg(&pdev->dev, "initialization successful.\n");
 
 	return 0;
 
-- 
1.8.3.1

