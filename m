Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaKUFrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:47:09 -0500
Received: from mail.eperm.de ([89.247.134.16]:54771 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKUFrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:47:08 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: user - add MODULE_ALIAS
Date: Fri, 21 Nov 2014 06:47:03 +0100
Message-ID: <1886949.maJD8yZxl6@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allow automatic loading of the crypto_user kernel module, the netlink
MODULE_ALIAS is added.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/crypto_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e2a34fe..255df95 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -537,3 +537,4 @@ module_exit(crypto_user_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_DESCRIPTION("Crypto userspace configuration API");
+MODULE_ALIAS("net-pf-16-proto-21");
-- 
2.1.0


