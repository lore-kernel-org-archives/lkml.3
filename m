Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab3HJRfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:35:16 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:43511 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab3HJRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:34:43 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="29009662"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 2/2] crypto/camellia_generic.c: adjust code alignment
Date: Sat, 10 Aug 2013 19:34:37 +0200
Message-Id: <1376156077-6208-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376156077-6208-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376156077-6208-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Adjust alignment in automatically generated code.  If this code
will not be regenerated in the future, it may as well look nice.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This patch was generated from the result of the previous one, which
replaced commas by semicolons.

 crypto/camellia_generic.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 125cf16..26bcd7a 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -389,7 +389,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	subL[7] ^= subL[1]; subR[7] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[9];
 	dw = subL[1] & subL[9];
-		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
+	subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl2) */
 	/* round 8 */
 	subL[11] ^= subL[1]; subR[11] ^= subR[1];
 	/* round 10 */
@@ -398,7 +398,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	subL[15] ^= subL[1]; subR[15] ^= subR[1];
 	subL[1] ^= subR[1] & ~subR[17];
 	dw = subL[1] & subL[17];
-		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
+	subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl4) */
 	/* round 14 */
 	subL[19] ^= subL[1]; subR[19] ^= subR[1];
 	/* round 16 */
@@ -414,7 +414,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	} else {
 		subL[1] ^= subR[1] & ~subR[25];
 		dw = subL[1] & subL[25];
-			subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
+		subR[1] ^= rol32(dw, 1); /* modified for FLinv(kl6) */
 		/* round 20 */
 		subL[27] ^= subL[1]; subR[27] ^= subR[1];
 		/* round 22 */
@@ -434,7 +434,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		subL[26] ^= kw4l; subR[26] ^= kw4r;
 		kw4l ^= kw4r & ~subR[24];
 		dw = kw4l & subL[24];
-			kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
+		kw4r ^= rol32(dw, 1); /* modified for FL(kl5) */
 	}
 	/* round 17 */
 	subL[22] ^= kw4l; subR[22] ^= kw4r;
@@ -444,7 +444,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	subL[18] ^= kw4l; subR[18] ^= kw4r;
 	kw4l ^= kw4r & ~subR[16];
 	dw = kw4l & subL[16];
-		kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
+	kw4r ^= rol32(dw, 1); /* modified for FL(kl3) */
 	/* round 11 */
 	subL[14] ^= kw4l; subR[14] ^= kw4r;
 	/* round 9 */
@@ -453,7 +453,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	subL[10] ^= kw4l; subR[10] ^= kw4r;
 	kw4l ^= kw4r & ~subR[8];
 	dw = kw4l & subL[8];
-		kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
+	kw4r ^= rol32(dw, 1); /* modified for FL(kl1) */
 	/* round 5 */
 	subL[6] ^= kw4l; subR[6] ^= kw4r;
 	/* round 3 */
@@ -478,7 +478,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_R(6) = subR[5] ^ subR[7];
 	tl = subL[10] ^ (subR[10] & ~subR[8]);
 	dw = tl & subL[8];  /* FL(kl1) */
-		tr = subR[10] ^ rol32(dw, 1);
+	tr = subR[10] ^ rol32(dw, 1);
 	SUBKEY_L(7) = subL[6] ^ tl; /* round 6 */
 	SUBKEY_R(7) = subR[6] ^ tr;
 	SUBKEY_L(8) = subL[8];       /* FL(kl1) */
@@ -487,7 +487,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_R(9) = subR[9];
 	tl = subL[7] ^ (subR[7] & ~subR[9]);
 	dw = tl & subL[9];  /* FLinv(kl2) */
-		tr = subR[7] ^ rol32(dw, 1);
+	tr = subR[7] ^ rol32(dw, 1);
 	SUBKEY_L(10) = tl ^ subL[11]; /* round 7 */
 	SUBKEY_R(10) = tr ^ subR[11];
 	SUBKEY_L(11) = subL[10] ^ subL[12]; /* round 8 */
@@ -500,7 +500,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_R(14) = subR[13] ^ subR[15];
 	tl = subL[18] ^ (subR[18] & ~subR[16]);
 	dw = tl & subL[16]; /* FL(kl3) */
-		tr = subR[18] ^ rol32(dw, 1);
+	tr = subR[18] ^ rol32(dw, 1);
 	SUBKEY_L(15) = subL[14] ^ tl; /* round 12 */
 	SUBKEY_R(15) = subR[14] ^ tr;
 	SUBKEY_L(16) = subL[16];     /* FL(kl3) */
@@ -509,7 +509,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	SUBKEY_R(17) = subR[17];
 	tl = subL[15] ^ (subR[15] & ~subR[17]);
 	dw = tl & subL[17]; /* FLinv(kl4) */
-		tr = subR[15] ^ rol32(dw, 1);
+	tr = subR[15] ^ rol32(dw, 1);
 	SUBKEY_L(18) = tl ^ subL[19]; /* round 13 */
 	SUBKEY_R(18) = tr ^ subR[19];
 	SUBKEY_L(19) = subL[18] ^ subL[20]; /* round 14 */
@@ -528,7 +528,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 	} else {
 		tl = subL[26] ^ (subR[26] & ~subR[24]);
 		dw = tl & subL[24]; /* FL(kl5) */
-			tr = subR[26] ^ rol32(dw, 1);
+		tr = subR[26] ^ rol32(dw, 1);
 		SUBKEY_L(23) = subL[22] ^ tl; /* round 18 */
 		SUBKEY_R(23) = subR[22] ^ tr;
 		SUBKEY_L(24) = subL[24];     /* FL(kl5) */
@@ -537,7 +537,7 @@ static void camellia_setup_tail(u32 *subkey, u32 *subL, u32 *subR, int max)
 		SUBKEY_R(25) = subR[25];
 		tl = subL[23] ^ (subR[23] & ~subR[25]);
 		dw = tl & subL[25]; /* FLinv(kl6) */
-			tr = subR[23] ^ rol32(dw, 1);
+		tr = subR[23] ^ rol32(dw, 1);
 		SUBKEY_L(26) = tl ^ subL[27]; /* round 19 */
 		SUBKEY_R(26) = tr ^ subR[27];
 		SUBKEY_L(27) = subL[26] ^ subL[28]; /* round 20 */

