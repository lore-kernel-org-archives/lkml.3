Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaE0PiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:38:04 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54141 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaE0Ph7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:37:59 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/15] staging: rtl8188eu:Remove unused macros defined in osdep_service.h
Date: Tue, 27 May 2014 21:05:55 +0530
Message-Id: <1401204955-4093-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
References: <1401204955-4093-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |   39 ---------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index b500991..3859acd 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -339,15 +339,7 @@ u64 rtw_division64(u64 x, u64 y);
 
 #define RTW_GET_BE24(a) ((((u32) (a)[0]) << 16) | (((u32) (a)[1]) << 8) | \
 			 ((u32) (a)[2]))
-#define RTW_PUT_BE24(a, val)					\
-	do {							\
-		(a)[0] = (u8) ((((u32) (val)) >> 16) & 0xff);	\
-		(a)[1] = (u8) ((((u32) (val)) >> 8) & 0xff);	\
-		(a)[2] = (u8) (((u32) (val)) & 0xff);		\
-	} while (0)
 
-#define RTW_GET_BE32(a) ((((u32) (a)[0]) << 24) | (((u32) (a)[1]) << 16) | \
-			 (((u32) (a)[2]) << 8) | ((u32) (a)[3]))
 #define RTW_PUT_BE32(a, val)					\
 	do {							\
 		(a)[0] = (u8) ((((u32) (val)) >> 24) & 0xff);	\
@@ -356,37 +348,6 @@ u64 rtw_division64(u64 x, u64 y);
 		(a)[3] = (u8) (((u32) (val)) & 0xff);		\
 	} while (0)
 
-#define RTW_GET_LE32(a) ((((u32) (a)[3]) << 24) | (((u32) (a)[2]) << 16) | \
-			 (((u32) (a)[1]) << 8) | ((u32) (a)[0]))
-#define RTW_PUT_LE32(a, val)					\
-	do {							\
-		(a)[3] = (u8) ((((u32) (val)) >> 24) & 0xff);	\
-		(a)[2] = (u8) ((((u32) (val)) >> 16) & 0xff);	\
-		(a)[1] = (u8) ((((u32) (val)) >> 8) & 0xff);	\
-		(a)[0] = (u8) (((u32) (val)) & 0xff);		\
-	} while (0)
-
-#define RTW_GET_BE64(a) ((((u64) (a)[0]) << 56) | (((u64) (a)[1]) << 48) | \
-			 (((u64) (a)[2]) << 40) | (((u64) (a)[3]) << 32) | \
-			 (((u64) (a)[4]) << 24) | (((u64) (a)[5]) << 16) | \
-			 (((u64) (a)[6]) << 8) | ((u64) (a)[7]))
-#define RTW_PUT_BE64(a, val)				\
-	do {						\
-		(a)[0] = (u8) (((u64) (val)) >> 56);	\
-		(a)[1] = (u8) (((u64) (val)) >> 48);	\
-		(a)[2] = (u8) (((u64) (val)) >> 40);	\
-		(a)[3] = (u8) (((u64) (val)) >> 32);	\
-		(a)[4] = (u8) (((u64) (val)) >> 24);	\
-		(a)[5] = (u8) (((u64) (val)) >> 16);	\
-		(a)[6] = (u8) (((u64) (val)) >> 8);	\
-		(a)[7] = (u8) (((u64) (val)) & 0xff);	\
-	} while (0)
-
-#define RTW_GET_LE64(a) ((((u64) (a)[7]) << 56) | (((u64) (a)[6]) << 48) | \
-			 (((u64) (a)[5]) << 40) | (((u64) (a)[4]) << 32) | \
-			 (((u64) (a)[3]) << 24) | (((u64) (a)[2]) << 16) | \
-			 (((u64) (a)[1]) << 8) | ((u64) (a)[0]))
-
 void rtw_buf_free(u8 **buf, u32 *buf_len);
 void rtw_buf_update(u8 **buf, u32 *buf_len, u8 *src, u32 src_len);
 
-- 
1.7.10.4

