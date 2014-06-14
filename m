Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaFNNV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:21:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54340 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbaFNNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:21:52 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH v2 2/2] staging: tidspbridge: Fix whitespace for pointers in function headers
Date: Sat, 14 Jun 2014 09:21:17 -0400
Message-Id: <1402752077-16297-2-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402752077-16297-1-git-send-email-jeffoczek@gmail.com>
References: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
 <1402752077-16297-1-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change style in function headers from 'type * ptr' to 'type *ptr'

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index e988e1e..a2ff7a1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
@@ -130,7 +130,7 @@ typedef s32(*dbll_seek_fxn) (void *, long, int);
  *      FALSE:          Failed to find symbol.
  */
 typedef bool(*dbll_sym_lookup) (void *handle, void *parg, void *rmm_handle,
-				const char *name, struct dbll_sym_val ** sym);
+				const char *name, struct dbll_sym_val **sym);
 
 /*
  *  ======== dbll_tell_fxn ========
@@ -309,7 +309,7 @@ typedef bool(*dbll_get_c_addr_fxn) (struct dbll_library_obj *lib, char *name,
  *  Ensures:
  */
 typedef int(*dbll_get_sect_fxn) (struct dbll_library_obj *lib,
-					char *name, u32 * addr, u32 * size);
+					char *name, u32 *addr, u32 *size);
 
 /*
  *  ======== dbll_init ========
-- 
1.9.1

