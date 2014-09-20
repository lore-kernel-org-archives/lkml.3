Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaITXa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 19:30:59 -0400
Received: from rgout06.bt.lon5.cpcloud.co.uk ([65.20.0.183]:11397 "EHLO
	rgout06.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaITXa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 19:30:58 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2014 19:30:58 EDT
X-CTCH-RefID: str=0001.0A090204.541E0CA9.004E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-Junkmail-Premium-Raw: score=28/50,refid=2.7.2:2014.9.19.71820:17:28.905,ip=31.50.239.172,rules=__HAS_FROM,
 __PHISH_FROM2, __FRAUD_WEBMAIL_FROM, __TO_MALFORMED_2, __TO_NO_NAME,
 __MULTIPLE_RCPTS_CC_X2, __SUBJ_ALPHA_END, __HAS_MSGID, __SANE_MSGID,
 __HAS_X_MAILER, __ANY_URI, __FRAUD_BODY_WEBMAIL, __URI_NO_WWW, __URI_NO_PATH,
 BODYTEXTP_SIZE_3000_LESS, BODY_SIZE_1200_1299, __MIME_TEXT_ONLY,
 RDNS_GENERIC_POOLED, __URI_NS, SXL_IP_DYNAMIC[172.239.50.31.fur], HTML_00_01,
 HTML_00_10, BODY_SIZE_5000_LESS, RDNS_SUSP_GENERIC, __PHISH_FROM,
 MULTIPLE_RCPTS, __PHISH_SPEAR_STRUCTURE_1, RDNS_SUSP, BODY_SIZE_2000_LESS,
 __FRAUD_WEBMAIL, BODY_SIZE_7000_LESS
X-CTCH-Spam: Unknown
From: Mike Roocroft <mike.linux@btinternet.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mike.linux@btinternet.com
Subject: [PATCH] Staging: Skein: skein_block: fixed 3 tab coding style isses
Date: Sun, 21 Sep 2014 00:27:07 +0100
Message-Id: <1411255627-27297-1-git-send-email-mike.linux@btinternet.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
---
 drivers/staging/skein/skein_block.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 04ce1d0..b969fe1 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -34,7 +34,7 @@
 
 #ifdef SKEIN_DEBUG
 #define debug_save_tweak(ctx) { \
-                        ctx->h.tweak[0] = ts[0]; ctx->h.tweak[1] = ts[1]; }
+			ctx->h.tweak[0] = ts[0]; ctx->h.tweak[1] = ts[1]; }
 #else
 #define debug_save_tweak(ctx)
 #endif
@@ -378,7 +378,7 @@ do { \
 	skein_show_r_ptr(BLK_BITS, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
-		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
+	for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
 #endif /* end of looped code definitions */
 		{
 #define R512_8_ROUNDS(R)  /* do 8 full rounds */  \
@@ -657,7 +657,7 @@ do { \
 	skein_show_r_ptr(BLK_BITSi, &ctx->h, SKEIN_RND_KEY_INJECT, X_ptr); \
 } while (0)
 
-		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
+	for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
 #endif
 		{
 #define R1024_8_ROUNDS(R) \
-- 
2.1.0

