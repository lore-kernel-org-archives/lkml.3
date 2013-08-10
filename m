Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3HJRfT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:35:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:9890 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab3HJRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:34:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="29009661"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: kernel-janitors@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH 1/2] arch/x86/crypto/camellia_glue.c: adjust code alignment
Date: Sat, 10 Aug 2013 19:34:36 +0200
Message-Id: <1376156077-6208-2-git-send-email-Julia.Lawall@lip6.fr>
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

 arch/x86/crypto/camellia_glue.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index ac2b28b..39aebea 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -829,7 +829,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	subRL[1] ^= (subRL[1] & ~subRL[9]) << 32;
 	/* modified for FLinv(kl2) */
 	dw = (subRL[1] & subRL[9]) >> 32;
-		subRL[1] ^= rol32(dw, 1);
+	subRL[1] ^= rol32(dw, 1);
 
 	/* round 8 */
 	subRL[11] ^= subRL[1];
@@ -841,7 +841,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	subRL[1] ^= (subRL[1] & ~subRL[17]) << 32;
 	/* modified for FLinv(kl4) */
 	dw = (subRL[1] & subRL[17]) >> 32;
-		subRL[1] ^= rol32(dw, 1);
+	subRL[1] ^= rol32(dw, 1);
 
 	/* round 14 */
 	subRL[19] ^= subRL[1];
@@ -860,7 +860,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		subRL[1] ^= (subRL[1] & ~subRL[25]) << 32;
 		/* modified for FLinv(kl6) */
 		dw = (subRL[1] & subRL[25]) >> 32;
-			subRL[1] ^= rol32(dw, 1);
+		subRL[1] ^= rol32(dw, 1);
 
 		/* round 20 */
 		subRL[27] ^= subRL[1];
@@ -883,7 +883,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 		kw4 ^= (kw4 & ~subRL[24]) << 32;
 		/* modified for FL(kl5) */
 		dw = (kw4 & subRL[24]) >> 32;
-			kw4 ^= rol32(dw, 1);
+		kw4 ^= rol32(dw, 1);
 	}
 
 	/* round 17 */
@@ -896,7 +896,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	kw4 ^= (kw4 & ~subRL[16]) << 32;
 	/* modified for FL(kl3) */
 	dw = (kw4 & subRL[16]) >> 32;
-		kw4 ^= rol32(dw, 1);
+	kw4 ^= rol32(dw, 1);
 
 	/* round 11 */
 	subRL[14] ^= kw4;
@@ -908,7 +908,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	kw4 ^= (kw4 & ~subRL[8]) << 32;
 	/* modified for FL(kl1) */
 	dw = (kw4 & subRL[8]) >> 32;
-		kw4 ^= rol32(dw, 1);
+	kw4 ^= rol32(dw, 1);
 
 	/* round 5 */
 	subRL[6] ^= kw4;
@@ -929,7 +929,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	tl = (subRL[10] >> 32) ^ (subRL[10] & ~subRL[8]);
 	dw = tl & (subRL[8] >> 32);				/* FL(kl1) */
-		tr = subRL[10] ^ rol32(dw, 1);
+	tr = subRL[10] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(7, subRL[6] ^ tt);			/* round 6 */
@@ -938,7 +938,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	tl = (subRL[7] >> 32) ^ (subRL[7] & ~subRL[9]);
 	dw = tl & (subRL[9] >> 32);				/* FLinv(kl2) */
-		tr = subRL[7] ^ rol32(dw, 1);
+	tr = subRL[7] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(10, subRL[11] ^ tt);			/* round 7 */
@@ -949,7 +949,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	tl = (subRL[18] >> 32) ^ (subRL[18] & ~subRL[16]);
 	dw = tl & (subRL[16] >> 32);				/* FL(kl3) */
-		tr = subRL[18] ^ rol32(dw, 1);
+	tr = subRL[18] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(15, subRL[14] ^ tt);			/* round 12 */
@@ -958,7 +958,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 	tl = (subRL[15] >> 32) ^ (subRL[15] & ~subRL[17]);
 	dw = tl & (subRL[17] >> 32);				/* FLinv(kl4) */
-		tr = subRL[15] ^ rol32(dw, 1);
+	tr = subRL[15] ^ rol32(dw, 1);
 	tt = (tr | ((u64)tl << 32));
 
 	SET_SUBKEY_LR(18, subRL[19] ^ tt);			/* round 13 */
@@ -973,7 +973,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 	} else {
 		tl = (subRL[26] >> 32) ^ (subRL[26] & ~subRL[24]);
 		dw = tl & (subRL[24] >> 32);			/* FL(kl5) */
-			tr = subRL[26] ^ rol32(dw, 1);
+		tr = subRL[26] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 
 		SET_SUBKEY_LR(23, subRL[22] ^ tt);		/* round 18 */
@@ -982,7 +982,7 @@ static void camellia_setup_tail(u64 *subkey, u64 *subRL, int max)
 
 		tl = (subRL[23] >> 32) ^ (subRL[23] & ~subRL[25]);
 		dw = tl & (subRL[25] >> 32);			/* FLinv(kl6) */
-			tr = subRL[23] ^ rol32(dw, 1);
+		tr = subRL[23] ^ rol32(dw, 1);
 		tt = (tr | ((u64)tl << 32));
 
 		SET_SUBKEY_LR(26, subRL[27] ^ tt);		/* round 19 */

