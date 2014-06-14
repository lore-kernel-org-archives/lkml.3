Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaFNCsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:48:31 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48486 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaFNCs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:48:29 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH 1/2] staging: tidspbridge: Fix pointer spacing
Date: Fri, 13 Jun 2014 22:48:12 -0400
Message-Id: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple coding style changes
This is for Eudyptula Challenge task 10

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index 30e0aa0..5e44ba6 100644
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

