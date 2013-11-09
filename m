Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3KIRhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 12:37:09 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:52597 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3KIRhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 12:37:05 -0500
From: Mickael Maison <mickael.maison@gmail.com>
To: dan.j.williams@intel.com
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickael Maison <mickael.maison@gmail.com>
Subject: [PATCH] CRYPTO: async_tx: Fixed a couple of typos
Date: Sat,  9 Nov 2013 18:30:14 +0100
Message-Id: <1384018214-28064-1-git-send-email-mickael.maison@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 2 typos in async_xor.c
---
 crypto/async_tx/async_xor.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 8ade0a0..bcaa1e9 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -48,7 +48,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 	int xor_src_cnt = 0;
 	dma_addr_t dma_dest;
 
-	/* map the dest bidrectional in case it is re-used as a source */
+	/* map the dest bidirectional in case it is re-used as a source */
 	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
 	for (i = 0; i < src_cnt; i++) {
 		/* only map the dest once */
@@ -175,7 +175,7 @@ do_sync_xor(struct page *dest, struct page **src_list, unsigned int offset,
  * xor_blocks always uses the dest as a source so the
  * ASYNC_TX_XOR_ZERO_DST flag must be set to not include dest data in
  * the calculation.  The assumption with dma eninges is that they only
- * use the destination buffer as a source when it is explicity specified
+ * use the destination buffer as a source when it is explicitly specified
  * in the source list.
  *
  * src_list note: if the dest is also a source it must be at index zero.
-- 
1.7.10.4

