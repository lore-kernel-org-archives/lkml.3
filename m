Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535Ab3HJPlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:41:25 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:27297
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934448Ab3HJPkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:40:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23671833"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 3/5] arch/x86/crypto/camellia_glue.c: convert comma to semicolon
Date: Sat, 10 Aug 2013 17:40:23 +0200
Message-Id: <1376149225-3997-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace a comma between expression statements by a semicolon.

A simplified version of the semantic patch that performs this
transformation is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression e1,e2,e;
type T;
identifier i;
@@

 e1
-,
+;
 e2;
// </smpl>

This patch is separate from the others because the source code appears to
be machine-generated.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/x86/crypto/camellia_glue.c |   24 +++++++-------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 5cb86cc..ac2b28b 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -828,7 +828,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	subRL[1] ^= (subRL[1] & ~subRL[9]) << 32;
 	/* modified for FLinv(kl2) */
-	dw = (subRL[1] & subRL[9]) >> 32,
+	dw = (subRL[1] & subRL[9]) >> 32;
 		subRL[1] ^= rol32(dw, 1);
 
 	/* round 8 */
@@ -840,7 +840,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	subRL[1] ^= (subRL[1] & ~subRL[17]) << 32;
 	/* modified for FLinv(kl4) */
-	dw = (subRL[1] & subRL[17]) >> 32,
+	dw = (subRL[1] & subRL[17]) >> 32;
 		subRL[1] ^= rol32(dw, 1);
 
 	/* round 14 */
@@ -859,7 +859,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	} else {
 		subRL[1] ^= (subRL[1] & ~subRL[25]) << 32;
 		/* modified for FLinv(kl6) */
-		dw = (subRL[1] & subRL[25]) >> 32,
+		dw = (subRL[1] & subRL[25]) >> 32;
 			subRL[1] ^= rol32(dw, 1);
 
 		/* round 20 */
@@ -882,7 +882,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 		kw4 ^= (kw4 & ~subRL[24]) << 32;
 		/* modified for FL(kl5) */
-		dw = (kw4 & subRL[24]) >> 32,
+		dw = (kw4 & subRL[24]) >> 32;
 			kw4 ^= rol32(dw, 1);
 	}
 
@@ -895,7 +895,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	kw4 ^= (kw4 & ~subRL[16]) << 32;
 	/* modified for FL(kl3) */
-	dw = (kw4 & subRL[16]) >> 32,
+	dw = (kw4 & subRL[16]) >> 32;
 		kw4 ^= rol32(dw, 1);
 
 	/* round 11 */
@@ -907,7 +907,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	kw4 ^= (kw4 & ~subRL[8]) << 32;
 	/* modified for FL(kl1) */
-	dw = (kw4 & subRL[8]) >> 32,
+	dw = (kw4 & subRL[8]) >> 32;
 		kw4 ^= rol32(dw, 1);
 
 	/* round 5 */
@@ -928,7 +928,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(6, subRL[5] ^ subRL[7]);			/* round 5 */
 
 	tl = (subRL[10] >> 32) ^ (subRL[10] & ~subRL[8]);
-	dw = tl & (subRL[8] >> 32),				/* FL(kl1) */
+	dw = tl & (subRL[8] >> 32);				/* FL(kl1) */
 		tr = subRL[10] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
@@ -937,7 +937,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(9, subRL[9]);				/* FLinv(kl2) */
 
 	tl = (subRL[7] >> 32) ^ (subRL[7] & ~subRL[9]);
-	dw = tl & (subRL[9] >> 32),				/* FLinv(kl2) */
+	dw = tl & (subRL[9] >> 32);				/* FLinv(kl2) */
 		tr = subRL[7] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
@@ -948,7 +948,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(14, subRL[13] ^ subRL[15]);		/* round 11 */
 
 	tl = (subRL[18] >> 32) ^ (subRL[18] & ~subRL[16]);
-	dw = tl & (subRL[16] >> 32),				/* FL(kl3) */
+	dw = tl & (subRL[16] >> 32);				/* FL(kl3) */
 		tr = subRL[18] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
@@ -957,7 +957,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(17, subRL[17]);				/* FLinv(kl4) */
 
 	tl = (subRL[15] >> 32) ^ (subRL[15] & ~subRL[17]);
-	dw = tl & (subRL[17] >> 32),				/* FLinv(kl4) */
+	dw = tl & (subRL[17] >> 32);				/* FLinv(kl4) */
 		tr = subRL[15] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
@@ -972,7 +972,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		SET_SUBKEY_LR(24, subRL[24] ^ subRL[23]);	/* kw3 */
 	} else {
 		tl = (subRL[26] >> 32) ^ (subRL[26] & ~subRL[24]);
-		dw = tl & (subRL[24] >> 32),			/* FL(kl5) */
+		dw = tl & (subRL[24] >> 32);			/* FL(kl5) */
 			tr = subRL[26] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 
@@ -981,7 +981,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		SET_SUBKEY_LR(25, subRL[25]);			/* FLinv(kl6) */
 
 		tl = (subRL[23] >> 32) ^ (subRL[23] & ~subRL[25]);
-		dw = tl & (subRL[25] >> 32),			/* FLinv(kl6) */
+		dw = tl & (subRL[25] >> 32);			/* FLinv(kl6) */
 			tr = subRL[23] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 

