Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3IQTpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:45:05 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54550 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753041Ab3IQTpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:45:04 -0400
X-Sasl-enc: ic//yCKifEHHcidWARvE/bvCMC8HT1qTg6oDYBYivKm2 1379447101
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, xuezhao.liu@emc.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: fix switch case statement indenting
Date: Tue, 17 Sep 2013 15:44:58 -0400
Message-Id: <1379447098-25870-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to lvfs_linux.c that fixes incorrect switch case statement
indenting found by checkpatch.pl.

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c | 50 ++++++++++++-------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 18e1b47..9d79eee 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -253,31 +253,31 @@ __s64 lprocfs_read_helper(struct lprocfs_counter *lc,
 		return 0;
 
 	switch (field) {
-		case LPROCFS_FIELDS_FLAGS_CONFIG:
-			ret = header->lc_config;
-			break;
-		case LPROCFS_FIELDS_FLAGS_SUM:
-			ret = lc->lc_sum;
-			if ((flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
-				ret += lc->lc_sum_irq;
-			break;
-		case LPROCFS_FIELDS_FLAGS_MIN:
-			ret = lc->lc_min;
-			break;
-		case LPROCFS_FIELDS_FLAGS_MAX:
-			ret = lc->lc_max;
-			break;
-		case LPROCFS_FIELDS_FLAGS_AVG:
-			ret = (lc->lc_max - lc->lc_min) / 2;
-			break;
-		case LPROCFS_FIELDS_FLAGS_SUMSQUARE:
-			ret = lc->lc_sumsquare;
-			break;
-		case LPROCFS_FIELDS_FLAGS_COUNT:
-			ret = lc->lc_count;
-			break;
-		default:
-			break;
+	case LPROCFS_FIELDS_FLAGS_CONFIG:
+		ret = header->lc_config;
+		break;
+	case LPROCFS_FIELDS_FLAGS_SUM:
+		ret = lc->lc_sum;
+		if ((flags & LPROCFS_STATS_FLAG_IRQ_SAFE) != 0)
+			ret += lc->lc_sum_irq;
+		break;
+	case LPROCFS_FIELDS_FLAGS_MIN:
+		ret = lc->lc_min;
+		break;
+	case LPROCFS_FIELDS_FLAGS_MAX:
+		ret = lc->lc_max;
+		break;
+	case LPROCFS_FIELDS_FLAGS_AVG:
+		ret = (lc->lc_max - lc->lc_min) / 2;
+		break;
+	case LPROCFS_FIELDS_FLAGS_SUMSQUARE:
+		ret = lc->lc_sumsquare;
+		break;
+	case LPROCFS_FIELDS_FLAGS_COUNT:
+		ret = lc->lc_count;
+		break;
+	default:
+		break;
 	};
 
 	return ret;
-- 
1.8.4

