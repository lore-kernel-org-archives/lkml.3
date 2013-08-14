Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3HNNxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:53:23 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4937 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759804Ab3HNNxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:53:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,877,1367964000"; 
   d="scan'208";a="29356468"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] arch/x86/crypto/camellia_glue.c: replace commas by semicolons and adjust code alignment
Date: Wed, 14 Aug 2013 15:52:57 +0200
Message-Id: <1376488378-10601-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Adjust alignment and replace commas by semicolons in automatically
generated code.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/x86/crypto/camellia_glue.c |   48 ++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 5cb86cc..39aebea 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -828,8 +828,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	subRL[1] ^= (subRL[1] & ~subRL[9]) << 32;
 	/* modified for FLinv(kl2) */
-	dw = (subRL[1] & subRL[9]) >> 32,
-		subRL[1] ^= rol32(dw, 1);
+	dw = (subRL[1] & subRL[9]) >> 32;
+	subRL[1] ^= rol32(dw, 1);
 
 	/* round 8 */
 	subRL[11] ^= subRL[1];
@@ -840,8 +840,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	subRL[1] ^= (subRL[1] & ~subRL[17]) << 32;
 	/* modified for FLinv(kl4) */
-	dw = (subRL[1] & subRL[17]) >> 32,
-		subRL[1] ^= rol32(dw, 1);
+	dw = (subRL[1] & subRL[17]) >> 32;
+	subRL[1] ^= rol32(dw, 1);
 
 	/* round 14 */
 	subRL[19] ^= subRL[1];
@@ -859,8 +859,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	} else {
 		subRL[1] ^= (subRL[1] & ~subRL[25]) << 32;
 		/* modified for FLinv(kl6) */
-		dw = (subRL[1] & subRL[25]) >> 32,
-			subRL[1] ^= rol32(dw, 1);
+		dw = (subRL[1] & subRL[25]) >> 32;
+		subRL[1] ^= rol32(dw, 1);
 
 		/* round 20 */
 		subRL[27] ^= subRL[1];
@@ -882,8 +882,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 		kw4 ^= (kw4 & ~subRL[24]) << 32;
 		/* modified for FL(kl5) */
-		dw = (kw4 & subRL[24]) >> 32,
-			kw4 ^= rol32(dw, 1);
+		dw = (kw4 & subRL[24]) >> 32;
+		kw4 ^= rol32(dw, 1);
 	}
 
 	/* round 17 */
@@ -895,8 +895,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	kw4 ^= (kw4 & ~subRL[16]) << 32;
 	/* modified for FL(kl3) */
-	dw = (kw4 & subRL[16]) >> 32,
-		kw4 ^= rol32(dw, 1);
+	dw = (kw4 & subRL[16]) >> 32;
+	kw4 ^= rol32(dw, 1);
 
 	/* round 11 */
 	subRL[14] ^= kw4;
@@ -907,8 +907,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	kw4 ^= (kw4 & ~subRL[8]) << 32;
 	/* modified for FL(kl1) */
-	dw = (kw4 & subRL[8]) >> 32,
-		kw4 ^= rol32(dw, 1);
+	dw = (kw4 & subRL[8]) >> 32;
+	kw4 ^= rol32(dw, 1);
 
 	/* round 5 */
 	subRL[6] ^= kw4;
@@ -928,8 +928,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(6, subRL[5] ^ subRL[7]);			/* round 5 */
 
 	tl = (subRL[10] >> 32) ^ (subRL[10] & ~subRL[8]);
-	dw = tl & (subRL[8] >> 32),				/* FL(kl1) */
-		tr = subRL[10] ^ rol32(dw, 1);
+	dw = tl & (subRL[8] >> 32);				/* FL(kl1) */
+	tr = subRL[10] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(7, subRL[6] ^ tt);			/* round 6 */
@@ -937,8 +937,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(9, subRL[9]);				/* FLinv(kl2) */
 
 	tl = (subRL[7] >> 32) ^ (subRL[7] & ~subRL[9]);
-	dw = tl & (subRL[9] >> 32),				/* FLinv(kl2) */
-		tr = subRL[7] ^ rol32(dw, 1);
+	dw = tl & (subRL[9] >> 32);				/* FLinv(kl2) */
+	tr = subRL[7] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(10, subRL[11] ^ tt);			/* round 7 */
@@ -948,8 +948,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(14, subRL[13] ^ subRL[15]);		/* round 11 */
 
 	tl = (subRL[18] >> 32) ^ (subRL[18] & ~subRL[16]);
-	dw = tl & (subRL[16] >> 32),				/* FL(kl3) */
-		tr = subRL[18] ^ rol32(dw, 1);
+	dw = tl & (subRL[16] >> 32);				/* FL(kl3) */
+	tr = subRL[18] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(15, subRL[14] ^ tt);			/* round 12 */
@@ -957,8 +957,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	SET_SUBKEY_LR(17, subRL[17]);				/* FLinv(kl4) */
 
 	tl = (subRL[15] >> 32) ^ (subRL[15] & ~subRL[17]);
-	dw = tl & (subRL[17] >> 32),				/* FLinv(kl4) */
-		tr = subRL[15] ^ rol32(dw, 1);
+	dw = tl & (subRL[17] >> 32);				/* FLinv(kl4) */
+	tr = subRL[15] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(18, subRL[19] ^ tt);			/* round 13 */
@@ -972,8 +972,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		SET_SUBKEY_LR(24, subRL[24] ^ subRL[23]);	/* kw3 */
 	} else {
 		tl = (subRL[26] >> 32) ^ (subRL[26] & ~subRL[24]);
-		dw = tl & (subRL[24] >> 32),			/* FL(kl5) */
-			tr = subRL[26] ^ rol32(dw, 1);
+		dw = tl & (subRL[24] >> 32);			/* FL(kl5) */
+		tr = subRL[26] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 
 		SET_SUBKEY_LR(23, subRL[22] ^ tt);		/* round 18 */
@@ -981,8 +981,8 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		SET_SUBKEY_LR(25, subRL[25]);			/* FLinv(kl6) */
 
 		tl = (subRL[23] >> 32) ^ (subRL[23] & ~subRL[25]);
-		dw = tl & (subRL[25] >> 32),			/* FLinv(kl6) */
-			tr = subRL[23] ^ rol32(dw, 1);
+		dw = tl & (subRL[25] >> 32);			/* FLinv(kl6) */
+		tr = subRL[23] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 
 		SET_SUBKEY_LR(26, subRL[27] ^ tt);		/* round 19 */

