Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaFNCsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:48:32 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41643 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaFNCsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:48:31 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH 2/2] staging: tidspbridge: Fix function pointer spacing in struct definition
Date: Fri, 13 Jun 2014 22:48:13 -0400
Message-Id: <1402714093-15404-2-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
References: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple coding style changes
This is for the Eudyptula Challenge task 10

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index 5e44ba6..dd3e6eb 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
@@ -168,11 +168,11 @@ struct dbll_attrs {
 	 *  These file manipulation functions should be compatible with the
 	 *  "C" run time library functions of the same name.
 	 */
-	 s32(*fread) (void *, size_t, size_t, void *);
-	 s32(*fseek) (void *, long, int);
-	 s32(*ftell) (void *);
-	 s32(*fclose) (void *);
-	void *(*fopen) (const char *, const char *);
+	 s32 (*fread)(void *, size_t, size_t, void *);
+	 s32 (*fseek)(void *, long, int);
+	 s32 (*ftell)(void *);
+	 s32 (*fclose)(void *);
+	void *(*fopen)(const char *, const char *);
 };
 
 /*
-- 
1.9.1

