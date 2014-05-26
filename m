Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaEZQH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59041 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/24] staging: rtl8188eu: Remove unused function pointer declaration.
Date: Mon, 26 May 2014 21:35:30 +0530
Message-Id: <1401120339-23667-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/odm_interface.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index 3fc3e3c..5338290 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -58,16 +58,6 @@ enum odm_h2c_cmd {
 	ODM_MAX_H2CCMD
 };
 
-/*  2012/02/17 MH For non-MP compile pass only. Linux does not support workitem. */
-/*  Suggest HW team to use thread instead of workitem. Windows also support the feature. */
-typedef void (*RT_WORKITEM_CALL_BACK)(void *pContext);
-
-/*  =========== Extern Variable ??? It should be forbidden. */
-
-/*  =========== EXtern Function Prototype */
-
-/*  Memory Relative Function. */
-
 /*  ODM Timer relative API. */
 
 void ODM_CancelTimer(struct odm_dm_struct *pDM_Odm, struct timer_list *pTimer);
-- 
1.7.10.4

