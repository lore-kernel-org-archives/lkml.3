Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbaFAMDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:03:01 -0400
Received: from mail.eperm.de ([89.247.134.16]:45722 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaFAMDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:03:00 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, aquini@redhat.com, joe@perches.com,
        pwalten@au1.ibm.com, jeremy.wayne.powell@gmail.com, clemens@ladisch.de
Subject: [PATCH v9 4/6] compile the DRBG code
Date: Sat, 31 May 2014 17:23:45 +0200
Message-ID: <2476497.pzJrbCkPdq@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <22272963.fKEMicLVWl@myon.chronox.de>
References: <22272963.fKEMicLVWl@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 38e64231..bfa94fa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
+obj-$(CONFIG_CRYTPO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
1.9.3


