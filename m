Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3KWPgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:36:25 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37063 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3KWPgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:36:22 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tomas.winkler@intel.com
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/3] [trivial] mei: Fix typo in mei/nfc.c
Date: Sun, 24 Nov 2013 00:36:13 +0900
Message-Id: <1385220974-3469-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
In-Reply-To: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
References: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comments and debug messages.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/misc/mei/nfc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/nfc.c b/drivers/misc/mei/nfc.c
index 994ca4a..7e8590e 100644
--- a/drivers/misc/mei/nfc.c
+++ b/drivers/misc/mei/nfc.c
@@ -163,7 +163,7 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			return 0;
 
 		default:
-			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
@@ -175,14 +175,14 @@ static int mei_nfc_build_bus_name(struct mei_nfc_dev *ndev)
 			ndev->bus_name = "pn544";
 			return 0;
 		default:
-			dev_err(&dev->pdev->dev, "Unknow radio type 0x%x\n",
+			dev_err(&dev->pdev->dev, "Unknown radio type 0x%x\n",
 				ndev->radio_type);
 
 			return -EINVAL;
 		}
 
 	default:
-		dev_err(&dev->pdev->dev, "Unknow vendor ID 0x%x\n",
+		dev_err(&dev->pdev->dev, "Unknown vendor ID 0x%x\n",
 			ndev->vendor_id);
 
 		return -EINVAL;
@@ -428,7 +428,7 @@ static void mei_nfc_init(struct work_struct *work)
 	mutex_unlock(&dev->device_lock);
 
 	if (mei_nfc_if_version(ndev) < 0) {
-		dev_err(&dev->pdev->dev, "Could not get the NFC interfave version");
+		dev_err(&dev->pdev->dev, "Could not get the NFC interface version");
 
 		goto err;
 	}
@@ -481,7 +481,7 @@ int mei_nfc_host_init(struct mei_device *dev)
 	struct mei_cl *cl_info, *cl = NULL;
 	int i, ret;
 
-	/* already initialzed */
+	/* already initialized */
 	if (ndev->cl_info)
 		return 0;
 
-- 
1.8.5.rc1.28.g7061504

