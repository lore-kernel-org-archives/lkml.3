Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3IIECN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:02:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25184 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3IIECM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:02:12 -0400
Message-ID: <522D4826.9040209@huawei.com>
Date: Mon, 9 Sep 2013 12:01:42 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <vinod.koul@intel.com>,
        <djbw@fb.com>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH RESEND] doc: Documentation/DMA-attributes.txt fix typo
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in Documentation/DMA-attributes.txt.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Rob Landley <rob@landley.net> 
---
 Documentation/DMA-attributes.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attributes.txt
index e59480d..cc2450d 100644
--- a/Documentation/DMA-attributes.txt
+++ b/Documentation/DMA-attributes.txt
@@ -13,7 +13,7 @@ all pending DMA writes to complete, and thus provides a mechanism to
 strictly order DMA from a device across all intervening busses and
 bridges.  This barrier is not specific to a particular type of
 interconnect, it applies to the system as a whole, and so its
-implementation must account for the idiosyncracies of the system all
+implementation must account for the idiosyncrasies of the system all
 the way from the DMA device to memory.
 
 As an example of a situation where DMA_ATTR_WRITE_BARRIER would be
@@ -60,7 +60,7 @@ such mapping is non-trivial task and consumes very limited resources
 Buffers allocated with this attribute can be only passed to user space
 by calling dma_mmap_attrs(). By using this API, you are guaranteeing
 that you won't dereference the pointer returned by dma_alloc_attr(). You
-can threat it as a cookie that must be passed to dma_mmap_attrs() and
+can treat it as a cookie that must be passed to dma_mmap_attrs() and
 dma_free_attrs(). Make sure that both of these also get this attribute
 set on each call.
 
@@ -82,7 +82,7 @@ to 'device' domain, what synchronizes CPU caches for the given region
 (usually it means that the cache has been flushed or invalidated
 depending on the dma direction). However, next calls to
 dma_map_{single,page,sg}() for other devices will perform exactly the
-same sychronization operation on the CPU cache. CPU cache sychronization
+same synchronization operation on the CPU cache. CPU cache synchronization
 might be a time consuming operation, especially if the buffers are
 large, so it is highly recommended to avoid it if possible.
 DMA_ATTR_SKIP_CPU_SYNC allows platform code to skip synchronization of
-- 
1.7.1


. 

