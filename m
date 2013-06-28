Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3F1M7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:59:07 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:52723 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab3F1M7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:59:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>, Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] fix typo in comment
Date: Fri, 28 Jun 2013 15:56:20 +0300
Message-ID: <1372424180-23969-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..733e4ef 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -397,7 +397,7 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *	@mask: Mask for type comparison
  *
  *	This function should not be used by new algorithm types.
- *	Plesae use crypto_alloc_tfm instead.
+ *	Please use crypto_alloc_tfm instead.
  *
  *	crypto_alloc_base() will first attempt to locate an already loaded
  *	algorithm.  If that fails and the kernel supports dynamically loadable
-- 
1.8.1.5


