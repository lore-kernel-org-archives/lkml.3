Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3KZHuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:50:04 -0500
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:3961
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003Ab3KZHuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:50:00 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1b2fh224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: <shh.xie@gmail.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>,
        Shaohui Xie <Shaohui.Xie@freescale.com>
Subject: [PATCH] crypto/caam/jr.c: include linux/of_address.h
Date: Tue, 26 Nov 2013 14:30:05 +0800
Message-ID: <1385447405-7784-1-git-send-email-shh.xie@gmail.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohui Xie <Shaohui.Xie@freescale.com>

to avoid a compile error:

drivers/crypto/caam/jr.c: In function 'caam_jr_probe':
drivers/crypto/caam/jr.c:468:2: error: implicit declaration of function
'of_iomap' [-Werror=implicit-function-declaration]
drivers/crypto/caam/jr.c:468:7: warning: assignment makes pointer from
integer without a cast [enabled by default]

Signed-off-by: Shaohui Xie <Shaohui.Xie@freescale.com>
---
 drivers/crypto/caam/jr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d23356d2..1d80bd3 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/of_irq.h>
+#include <linux/of_address.h>
 
 #include "compat.h"
 #include "regs.h"
-- 
1.8.4.1


