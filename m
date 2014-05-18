Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaERPXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:23:46 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52156 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaERPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:23:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/28] staging: rtl8188eu: Remove unused structure rf_shadow
Date: Sun, 18 May 2014 20:49:07 +0530
Message-Id: <1400426361-19596-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index b1cb5c4..2f1348f 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -46,28 +46,6 @@
 
 #include <rtl8188e_hal.h>
 
-/*---------------------------Define Local Constant---------------------------*/
-/*  Define local structure for debug!!!!! */
-struct rf_shadow {
-	/*  Shadow register value */
-	u32 Value;
-	/*  Compare or not flag */
-	u8 Compare;
-	/*  Record If it had ever modified unpredicted */
-	u8 ErrorOrNot;
-	/*  Recorver Flag */
-	u8 Recorver;
-	/*  */
-	u8 Driver_Write;
-};
-
-/*---------------------------Define Local Constant---------------------------*/
-
-
-/*------------------------Define global variable-----------------------------*/
-
-/*------------------------Define local variable------------------------------*/
-
 /*-----------------------------------------------------------------------------
  * Function:	RF_ChangeTxPath
  *
-- 
1.7.10.4

