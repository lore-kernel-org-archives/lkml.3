Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaKQNRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:17:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:6077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaKQNRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:17:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="609081153"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kmx61: Use KMX61_DRV_NAME instead of hardcoded value
Date: Mon, 17 Nov 2014 15:18:36 +0200
Message-Id: <1416230316-14511-3-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416230316-14511-1-git-send-email-daniel.baluta@intel.com>
References: <1416230316-14511-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index e49b1cc..8c4b365 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -578,7 +578,7 @@ MODULE_DEVICE_TABLE(i2c, kmx61_id);
 
 static struct i2c_driver kmx61_driver = {
 	.driver = {
-		.name = "kmx61",
+		.name = KMX61_DRV_NAME,
 	},
 	.probe		= kmx61_probe,
 	.remove		= kmx61_remove,
-- 
1.9.1

