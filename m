Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaEFVkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:40:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51866 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEFVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:40:09 -0400
X-Originating-IP: 78.232.94.57
From: Remi Pommarel <repk@triplefau.lt>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] Staging: rtl8188eu: Fixed prohibited spaces after open '('
Date: Tue,  6 May 2014 23:40:50 +0200
Message-Id: <1399412450-28993-1-git-send-email-repk@triplefau.lt>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all prohibited spaces  after open '(' checkpatch.pl errors
for rtl8188eu.

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 drivers/staging/rtl8188eu/include/odm_debug.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/odm_debug.h b/drivers/staging/rtl8188eu/include/odm_debug.h
index e8c4cab..db7b44e 100644
--- a/drivers/staging/rtl8188eu/include/odm_debug.h
+++ b/drivers/staging/rtl8188eu/include/odm_debug.h
@@ -85,7 +85,7 @@
 /*------------------------Export Marco Definition---------------------------*/
 #define DbgPrint	pr_info
 #define RT_PRINTK(fmt, args...)				\
-	DbgPrint( "%s(): " fmt, __func__, ## args);
+	DbgPrint("%s(): " fmt, __func__, ## args);
 
 #ifndef ASSERT
 	#define ASSERT(expr)
@@ -106,8 +106,8 @@
 
 #define ODM_RT_ASSERT(pDM_Odm, expr, fmt)				\
 	if (!(expr)) {							\
-		DbgPrint( "Assertion failed! %s at ......\n", #expr);	\
-		DbgPrint( "      ......%s,%s,line=%d\n", __FILE__,	\
+		DbgPrint("Assertion failed! %s at ......\n", #expr);	\
+		DbgPrint("      ......%s,%s,line=%d\n", __FILE__,	\
 			__func__, __LINE__);				\
 		RT_PRINTK fmt;						\
 		ASSERT(false);						\
-- 
1.8.5.1

