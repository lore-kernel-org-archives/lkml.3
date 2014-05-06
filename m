Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaEFUFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:05:05 -0400
Received: from blu0-omc1-s26.blu0.hotmail.com ([65.55.116.37]:40423 "EHLO
	blu0-omc1-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbaEFUFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:05:04 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2014 16:05:03 EDT
X-TMN: [ovZbNBdR3RWzMyqTu2nKjf+2omRnBGwb]
X-Originating-Email: [poulecaca@msn.com]
Message-ID: <BLU436-SMTP123832E2D1B174A82D6FACA64F0@phx.gbl>
From: =?utf-8?B?UsOpbWkgUG9tbWFyZWw=?= <poulecaca@msn.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH] Staging: rtl8188eu: Fixed prohibited spaces after open '('
Date: Tue, 6 May 2014 22:00:38 +0200
X-Mailer: git-send-email 1.8.5.1
X-OriginalArrivalTime: 06 May 2014 19:59:55.0134 (UTC) FILETIME=[C00721E0:01CF6965]
MIME-Version: 1.0
Content-Type: text/plain
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

