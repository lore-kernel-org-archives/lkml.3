Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942Ab3HNNxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:53:04 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4937 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759725Ab3HNNxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:53:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,877,1367964000"; 
   d="scan'208";a="29356469"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto/camellia_generic.c: replace commas by semicolons and adjust code alignment
Date: Wed, 14 Aug 2013 15:52:58 +0200
Message-Id: <1376488378-10601-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Adjust alignment and replace commas by semicolons in automatically
generated code.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 crypto/camellia_generic.c |   48 +++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 75efa20..26bcd7a 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -388,8 +388,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 6 */
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
-	dw = subL[1] & subL[9],
-		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
+	dw = subL[1] & subL[9];
+	subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
@@ -397,8 +397,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 12 */
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
-	dw = subL[1] & subL[17],
-		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
+	dw = subL[1] & subL[17];
+	subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
@@ -413,8 +413,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		kw4l = subL[25]; kw4r = subR[25];
 	} else {
 		subL[1] ^= subR[1] & ~subR[25];
-		dw = subL[1] & subL[25],
-			subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
+		dw = subL[1] & subL[25];
+		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
 		/* round 20 */
 		subL[27] ^= subL[1]; subR[27] ^= subR[1];
 		/* round 22 */
@@ -433,8 +433,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		/* round 19 */
 		subL[26] ^= kw4l; subR[26] ^= kw4r;
 		kw4l ^= kw4r & ~subR[24];
-		dw = kw4l & subL[24],
-			kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
+		dw = kw4l & subL[24];
+		kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
 	}
 	/* round 17 */
 	subL[22] ^= kw4l; subR[22] ^= kw4r;
@@ -443,8 +443,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 13 */
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
-	dw = kw4l & subL[16],
-		kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
+	dw = kw4l & subL[16];
+	kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
@@ -452,8 +452,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 7 */
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
-	dw = kw4l & subL[8],
-		kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
+	dw = kw4l & subL[8];
+	kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
@@ -477,8 +477,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
 	SUBKEY_R(6) = subR[5] ^ subR[7];
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = tl & subL[8],  /* FL(kl1) */
-		tr = subR[10] ^ rol32(dw, 1);
+	dw = tl & subL[8];  /* FL(kl1) */
+	tr = subR[10] ^ rol32(dw, 1);
 	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
 	SUBKEY_R(7) = subR[6] ^ tr;
 	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
@@ -486,8 +486,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
 	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
-	dw = tl & subL[9],  /* FLinv(kl2) */
-		tr = subR[7] ^ rol32(dw, 1);
+	dw = tl & subL[9];  /* FLinv(kl2) */
+	tr = subR[7] ^ rol32(dw, 1);
 	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
 	SUBKEY_R(10) = tr ^ subR[11];
 	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
@@ -499,8 +499,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
 	SUBKEY_R(14) = subR[13] ^ subR[15];
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
-	dw = tl & subL[16], /* FL(kl3) */
-		tr = subR[18] ^ rol32(dw, 1);
+	dw = tl & subL[16]; /* FL(kl3) */
+	tr = subR[18] ^ rol32(dw, 1);
 	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
 	SUBKEY_R(15) = subR[14] ^ tr;
 	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
@@ -508,8 +508,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
 	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
-	dw = tl & subL[17], /* FLinv(kl4) */
-		tr = subR[15] ^ rol32(dw, 1);
+	dw = tl & subL[17]; /* FLinv(kl4) */
+	tr = subR[15] ^ rol32(dw, 1);
 	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
 	SUBKEY_R(18) = tr ^ subR[19];
 	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
@@ -527,8 +527,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_R(24) = subR[24] ^ subR[23];
 	} else {
 		tl = subL[26] ^ (subR[26] & ~subR[24]);
-		dw = tl & subL[24], /* FL(kl5) */
-			tr = subR[26] ^ rol32(dw, 1);
+		dw = tl & subL[24]; /* FL(kl5) */
+		tr = subR[26] ^ rol32(dw, 1);
 		SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
 		SUBKEY_R(23) = subR[22] ^ tr;
 		SUBKEY_L(24) = subL[24];     /* FL(kl5) */
@@ -536,8 +536,8 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
 		SUBKEY_R(25) = subR[25];
 		tl = subL[23] ^ (subR[23] & ~subR[25]);
-		dw = tl & subL[25], /* FLinv(kl6) */
-			tr = subR[23] ^ rol32(dw, 1);
+		dw = tl & subL[25]; /* FLinv(kl6) */
+		tr = subR[23] ^ rol32(dw, 1);
 		SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
 		SUBKEY_R(26) = tr ^ subR[27];
 		SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */

