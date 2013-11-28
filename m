Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3K1RQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:16:41 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:43468
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756577Ab3K1RQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:16:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>,
        Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] crypto: remove unnecessary includes
Date: Thu, 28 Nov 2013 19:16:27 +0200
Message-ID: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/authenc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 1875e70..7d4bfaa 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -17,11 +17,8 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
 
 typedef u8 *(*authenc_ahash_t)(struct aead_request *req, unsigned int flags);
 
-- 
1.7.11.7


