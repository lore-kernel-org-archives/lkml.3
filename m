Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaI3R0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:26:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35651 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaI3R0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:26:31 -0400
From: Karthik Nayak <karthik.188@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gamerh2o@gmail.com, gregkh@linuxfoundation.org,
        mark.einon@gmail.com, Karthik Nayak <karthik.188@gmail.com>
Subject: [PATCH] staging: bcm: multiple checkpatch fixes for InterfaceIdleMode.c
Date: Tue, 30 Sep 2014 22:56:17 +0530
Message-Id: <1412097977-3254-1-git-send-email-karthik.188@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. WARNING: else is not generally useful after a break or return

2. WARNING: quoted string split across lines

3. WARNING: break quoted strings at a space character

Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
---
 drivers/staging/bcm/InterfaceIdleMode.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index c84ee49..9a77a98 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -188,10 +188,9 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter,
 			5000);
 		if (status)
 			return status;
-		else
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-				IDLE_MODE, DBG_LVL_ALL,
-				"NOB Sent down :%d", lenwritten);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+			IDLE_MODE, DBG_LVL_ALL,
+			"NOB Sent down :%d", lenwritten);
 
 		/* mdelay(25); */
 
@@ -211,8 +210,8 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter,
 		else
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
 				IDLE_MODE, DBG_LVL_ALL,
-				"Number of completed iteration to"
-				"read chip-id :%lu", itr);
+				"Number of completed iteration to read chip-id :%lu",
+					itr);
 
 		status = wrmalt(Adapter, SW_ABORT_IDLEMODE_LOC,
 				&Pattern, sizeof(status));
-- 
2.1.0

