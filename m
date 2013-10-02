Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3JBP5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:57:18 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63222 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3JBP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:57:14 -0400
From: Kevin Mulvey <kevin@kevinmulvey.net>
To: herbert@gondor.hengli.com.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Mulvey <kevin@kevinmulvey.net>
Subject: [PATCH] Crypto: change all occurances of "kerneli" to kernel Bug #60848
Date: Wed,  2 Oct 2013 11:56:23 -0400
Message-Id: <1380729383-42275-1-git-send-email-kevin@kevinmulvey.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace all kerneli with kernel

Signed-off-by: Kevin Mulvey <kevin@kevinmulvey.net>
---
 crypto/Kconfig           | 2 +-
 crypto/serpent_generic.c | 2 +-
 crypto/testmgr.h         | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..84698cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1084,7 +1084,7 @@ config CRYPTO_SERPENT
 
 	  Keys are allowed to be from 0 to 256 bits in length, in steps
 	  of 8 bits.  Also includes the 'Tnepres' algorithm, a reversed
-	  variant of Serpent for compatibility with old kerneli.org code.
+	  variant of Serpent for compatibility with old kernel.org code.
 
 	  See also:
 	  <http://www.cl.cam.ac.uk/~rja14/serpent.html>
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 7ddbd7e..03f58b1 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -663,7 +663,7 @@ module_init(serpent_mod_init);
 module_exit(serpent_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Serpent and tnepres (kerneli compatible serpent reversed) Cipher Algorithm");
+MODULE_DESCRIPTION("Serpent and tnepres (kernel compatible serpent reversed) Cipher Algorithm");
 MODULE_AUTHOR("Dag Arne Osvik <osvik@ii.uib.no>");
 MODULE_ALIAS("tnepres");
 MODULE_ALIAS("serpent");
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 7d44aa3..e791172 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -585,7 +585,7 @@ static struct hash_testvec sha256_tv_template[] = {
 };
 
 /*
- * SHA384 test vectors from from NIST and kerneli
+ * SHA384 test vectors from from NIST and kernel
  */
 #define SHA384_TEST_VECTORS	4
 
@@ -634,7 +634,7 @@ static struct hash_testvec sha384_tv_template[] = {
 };
 
 /*
- * SHA512 test vectors from from NIST and kerneli
+ * SHA512 test vectors from from NIST and kernel
  */
 #define SHA512_TEST_VECTORS	4
 
-- 
1.8.1.4

