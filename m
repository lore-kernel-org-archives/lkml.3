Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3CDNAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:00:12 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54212 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab3CDNAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:00:08 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v3 23/23] remove unused random32() and srandom32()
Date: Mon,  4 Mar 2013 21:58:31 +0900
Message-Id: <1362401911-14074-24-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After finishing a naming transition, remove unused backward
compatibility wrapper macros

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---

No change from v2

 include/linux/random.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/random.h b/include/linux/random.h
index 347ce55..3b9377d 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -29,13 +29,6 @@ u32 prandom_u32(void);
 void prandom_bytes(void *buf, int nbytes);
 void prandom_seed(u32 seed);
 
-/*
- * These macros are preserved for backward compatibility and should be
- * removed as soon as a transition is finished.
- */
-#define random32() prandom_u32()
-#define srandom32(seed) prandom_seed(seed)
-
 u32 prandom_u32_state(struct rnd_state *);
 void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
 
-- 
1.8.1.2

