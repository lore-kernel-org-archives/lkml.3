Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaFWAmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:42:25 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:55192 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaFWAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:42:22 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 3/4] staging: rtl8712: remove unused inline _RND256()
Date: Sun, 22 Jun 2014 20:27:57 -0400
Message-Id: <1403483278-7343-3-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403483278-7343-2-git-send-email-shack@linux.com>
References: <1403483278-7343-1-git-send-email-shack@linux.com>
 <1403483278-7343-2-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 37ec56b..9316eab 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -184,11 +184,6 @@ static inline void flush_signals_thread(void)
 		flush_signals(current);
 }
 
-static inline u32 _RND256(u32 sz)
-{
-	return ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
-}
-
 static inline u32 _RND512(u32 sz)
 {
 	return ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
-- 
1.7.9.5

