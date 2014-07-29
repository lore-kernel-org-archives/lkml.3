Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaG2TuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaG2TuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:50:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH] crypto/testmgr: add missing spaces to drbg error strings
Date: Tue, 29 Jul 2014 15:47:56 -0400
Message-Id: <1406663276-25549-1-git-send-email-jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few missing spaces in the error text strings for
drbg_cavs_test, trivial fix.

CC: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-crypto@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 crypto/testmgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 81818b9..ac2b631 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1778,7 +1778,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 
 	drng = crypto_alloc_rng(driver, type, mask);
 	if (IS_ERR(drng)) {
-		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for"
+		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
 		kzfree(buf);
 		return -ENOMEM;
@@ -1803,7 +1803,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 			buf, test->expectedlen, &addtl);
 	}
 	if (ret <= 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for"
+		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
@@ -1818,7 +1818,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 			buf, test->expectedlen, &addtl);
 	}
 	if (ret <= 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for"
+		printk(KERN_ERR "alg: drbg: could not obtain random data for "
 		       "driver %s\n", driver);
 		goto outbuf;
 	}
-- 
1.8.3.1

