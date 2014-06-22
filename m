Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFVIiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:38:07 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35675 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaFVIiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:38:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 25/42] staging: rtl8188eu: Remove unused inline function _RND512()
Date: Sun, 22 Jun 2014 14:06:31 +0530
Message-Id: <1403426208-12413-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index bc1ffd4..27a610f 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -222,14 +222,6 @@ static inline u32 _RND256(u32 sz)
 	return val;
 }
 
-static inline u32 _RND512(u32 sz)
-{
-	u32	val;
-
-	val = ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
-	return val;
-}
-
 static inline u32 bitshift(u32 bitmask)
 {
 	u32 i;
-- 
1.7.10.4

