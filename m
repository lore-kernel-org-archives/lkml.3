Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3GQMOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:55706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3GQMOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="346987191"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.11 1/4] mei: hbm: fix typo in error message
Date: Wed, 17 Jul 2013 15:13:14 +0300
Message-Id: <1374063197-26855-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

writet -> write

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index f9296ab..6127ab6 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -167,7 +167,7 @@ int mei_hbm_start_req(struct mei_device *dev)
 
 	dev->hbm_state = MEI_HBM_IDLE;
 	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
-		dev_err(&dev->pdev->dev, "version message writet failed\n");
+		dev_err(&dev->pdev->dev, "version message write failed\n");
 		dev->dev_state = MEI_DEV_RESETTING;
 		mei_reset(dev, 1);
 		return -ENODEV;
-- 
1.8.1.2

