Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaEaTrr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:47:47 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:49233 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaEaTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:47:44 -0400
Message-ID: <538A31DE.3030004@gmail.com>
Date: Sat, 31 May 2014 22:47:42 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: ion: ion_chunk_heap.c: Fix checkpatch warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the over 80 character line

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/android/ion/ion_chunk_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 3f2c12b..9c3e49a 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -106,7 +106,7 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 
 	if (ion_buffer_cached(buffer))
 		dma_sync_sg_for_device(NULL, table->sgl, table->nents,
-								DMA_BIDIRECTIONAL);
+							DMA_BIDIRECTIONAL);
 
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
-- 
1.9.1


