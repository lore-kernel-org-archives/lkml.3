Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab3HJPke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:40:34 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:21362
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934440Ab3HJPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:40:32 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="23671831"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 2/5] crypto/camellia_generic.c: convert comma to semicolon
Date: Sat, 10 Aug 2013 17:40:22 +0200
Message-Id: <1376149225-3997-3-git-send-email-Julia.Lawall@lip6.fr>
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

This patch is separate from the others because the code appears to be
machine-generated.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 crypto/camellia_generic.c |   24 ++++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 75efa20..125cf16 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -388,7 +388,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 6 */
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
-	dw = subL[1] & subL[9],
+	dw = subL[1] & subL[9];
 		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
@@ -397,7 +397,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 12 */
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
-	dw = subL[1] & subL[17],
+	dw = subL[1] & subL[17];
 		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
@@ -413,7 +413,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		kw4l = subL[25]; kw4r = subR[25];
 	} else {
 		subL[1] ^= subR[1] & ~subR[25];
-		dw = subL[1] & subL[25],
+		dw = subL[1] & subL[25];
 			subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
 		/* round 20 */
 		subL[27] ^= subL[1]; subR[27] ^= subR[1];
@@ -433,7 +433,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		/* round 19 */
 		subL[26] ^= kw4l; subR[26] ^= kw4r;
 		kw4l ^= kw4r & ~subR[24];
-		dw = kw4l & subL[24],
+		dw = kw4l & subL[24];
 			kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
 	}
 	/* round 17 */
@@ -443,7 +443,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 13 */
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
-	dw = kw4l & subL[16],
+	dw = kw4l & subL[16];
 		kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
@@ -452,7 +452,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	/* round 7 */
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
-	dw = kw4l & subL[8],
+	dw = kw4l & subL[8];
 		kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
@@ -477,7 +477,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(6) = subL[5] ^ subL[7]; /* round 5 */
 	SUBKEY_R(6) = subR[5] ^ subR[7];
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
-	dw = tl & subL[8],  /* FL(kl1) */
+	dw = tl & subL[8];  /* FL(kl1) */
 		tr = subR[10] ^ rol32(dw, 1);
 	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
 	SUBKEY_R(7) = subR[6] ^ tr;
@@ -486,7 +486,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(9) = subL[9];       /* FLinv(kl2) */
 	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
-	dw = tl & subL[9],  /* FLinv(kl2) */
+	dw = tl & subL[9];  /* FLinv(kl2) */
 		tr = subR[7] ^ rol32(dw, 1);
 	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
 	SUBKEY_R(10) = tr ^ subR[11];
@@ -499,7 +499,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(14) = subL[13] ^ subL[15]; /* round 11 */
 	SUBKEY_R(14) = subR[13] ^ subR[15];
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
-	dw = tl & subL[16], /* FL(kl3) */
+	dw = tl & subL[16]; /* FL(kl3) */
 		tr = subR[18] ^ rol32(dw, 1);
 	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
 	SUBKEY_R(15) = subR[14] ^ tr;
@@ -508,7 +508,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_L(17) = subL[17];     /* FLinv(kl4) */
 	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
-	dw = tl & subL[17], /* FLinv(kl4) */
+	dw = tl & subL[17]; /* FLinv(kl4) */
 		tr = subR[15] ^ rol32(dw, 1);
 	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
 	SUBKEY_R(18) = tr ^ subR[19];
@@ -527,7 +527,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_R(24) = subR[24] ^ subR[23];
 	} else {
 		tl = subL[26] ^ (subR[26] & ~subR[24]);
-		dw = tl & subL[24], /* FL(kl5) */
+		dw = tl & subL[24]; /* FL(kl5) */
 			tr = subR[26] ^ rol32(dw, 1);
 		SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
 		SUBKEY_R(23) = subR[22] ^ tr;
@@ -536,7 +536,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_L(25) = subL[25];     /* FLinv(kl6) */
 		SUBKEY_R(25) = subR[25];
 		tl = subL[23] ^ (subR[23] & ~subR[25]);
-		dw = tl & subL[25], /* FLinv(kl6) */
+		dw = tl & subL[25]; /* FLinv(kl6) */
 			tr = subR[23] ^ rol32(dw, 1);
 		SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
 		SUBKEY_R(26) = tr ^ subR[27];

