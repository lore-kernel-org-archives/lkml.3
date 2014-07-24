Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbaGXDfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:35:21 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63178 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaGXDfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:20 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Gokulnath.Avanashilingam@in.bosch.com, peter.senna@gmail.com,
        lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Join lines in IntefaceIdleMode.c
Date: Wed, 23 Jul 2014 23:35:15 -0400
Message-Id: <1406172915-6663-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This joins two lines that need to be joined as this improves
the coding style and makes it much easier to read.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/bcm/InterfaceIdleMode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceIdleMode.c b/drivers/staging/bcm/InterfaceIdleMode.c
index c84ee49..e075f0e 100644
--- a/drivers/staging/bcm/InterfaceIdleMode.c
+++ b/drivers/staging/bcm/InterfaceIdleMode.c
@@ -211,8 +211,7 @@ static int InterfaceAbortIdlemode(struct bcm_mini_adapter *Adapter,
 		else
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
 				IDLE_MODE, DBG_LVL_ALL,
-				"Number of completed iteration to"
-				"read chip-id :%lu", itr);
+				"Number of completed iteration to read chip-id :%lu", itr);
 
 		status = wrmalt(Adapter, SW_ABORT_IDLEMODE_LOC,
 				&Pattern, sizeof(status));
-- 
1.9.1

