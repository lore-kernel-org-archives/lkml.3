Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaI3GNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:13:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56190 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaI3GNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:13:06 -0400
Date: Tue, 30 Sep 2014 01:10:48 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] staging: skein: Additional Whitespace Issues
Message-ID: <86fca4750dfba1c25d7d8b3b5cb5f019e756fed7.1412056800.git.eric.rost@mybabylon.net>
References: <cover.1412056799.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1412056799.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes leading and trailing whitespace issues.
Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_block.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index d49709c..71c14f5 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -36,7 +36,7 @@
 #define debug_save_tweak(ctx)       \
 {                                   \
 	ctx->h.tweak[0] = ts[0];    \
-       	ctx->h.tweak[1] = ts[1];    \
+	ctx->h.tweak[1] = ts[1];    \
 }
 #else
 #define debug_save_tweak(ctx)
@@ -139,7 +139,7 @@ do {                                                                      \
 	X3   += ks[((R) + 4) % 5] + (R) + 1;                              \
 	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
-#else 
+#else
 /* looping version */
 #define R256(p0, p1, p2, p3, ROT, r_num) \
 do { \
@@ -531,20 +531,20 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 #ifdef SKEIN_DEBUG
 	const u64 *X_ptr[16]; /* use for debugging (help cc put Xn in regs) */
 
-	X_ptr[0] = &X00; 
-       	X_ptr[1] = &X01;  
+	X_ptr[0] = &X00;
+	X_ptr[1] = &X01;
 	X_ptr[2] = &X02;
-	X_ptr[3] = &X03;  
-	X_ptr[4] = &X04;  
+	X_ptr[3] = &X03;
+	X_ptr[4] = &X04;
 	X_ptr[5] = &X05;
-	X_ptr[6] = &X06;  
-	X_ptr[7] = &X07;  
+	X_ptr[6] = &X06;
+	X_ptr[7] = &X07;
 	X_ptr[8] = &X08;
-	X_ptr[9] = &X09;  
-	X_ptr[10] = &X10;  
+	X_ptr[9] = &X09;
+	X_ptr[10] = &X10;
 	X_ptr[11] = &X11;
-	X_ptr[12] = &X12;  
-	X_ptr[13] = &X13;  
+	X_ptr[12] = &X12;
+	X_ptr[13] = &X13;
 	X_ptr[14] = &X14;
 	X_ptr[15] = &X15;
 #endif
@@ -589,7 +589,7 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 		skein_show_block(BLK_BITS, &ctx->h, ctx->x, blk_ptr, w, ks, ts);
 
 		/* do the first full key injection */
-		X00 = w[0] + ks[0]; 
+		X00 = w[0] + ks[0];
 		X01 = w[1] + ks[1];
 		X02 = w[2] + ks[2];
 		X03 = w[3] + ks[3];
@@ -614,7 +614,7 @@ void skein_1024_process_block(struct skein_1024_ctx *ctx, const u8 *blk_ptr,
 do {                                                                          \
 	X##p0 += X##p1;                                                       \
 	X##p1 = rotl_64(X##p1, ROT##_0);                                      \
-       	X##p1 ^= X##p0;                                                       \
+	X##p1 ^= X##p0;                                                       \
 	X##p2 += X##p3;                                                       \
 	X##p3 = rotl_64(X##p3, ROT##_1);                                      \
 	X##p3 ^= X##p2;                                                       \
-- 
1.7.10.4

