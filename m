Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaG3Diw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:38:52 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:35181 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754663AbaG3Dit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:38:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1534:1539:1567:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4321:4385:5007:6114:6119:6261:6642:10004:10026:10848:11232:11657:11658:11914:12043:12517:12519:12555:12679:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pies25_4ce63fd034f41
X-Filterd-Recvd-Size: 1525
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] MAINTAINERS: Update DMA BUFFER SHARING patterns
Date: Tue, 29 Jul 2014 20:38:39 -0700
Message-Id: <0c84bc47f6fe383b7d2cf2f77ed831be570aba0b.1406691397.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1406691397.git.joe@perches.com>
References: <cover.1406691397.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One pattern per F: line please...

Signed-off-by: Joe Perches <joe@perches.com>
CC: Sumit Semwal <sumit.semwal@linaro.org>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e5478b..66d5894 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2941,7 +2941,9 @@ L:	linux-media@vger.kernel.org
 L:	dri-devel@lists.freedesktop.org
 L:	linaro-mm-sig@lists.linaro.org
 F:	drivers/dma-buf/
-F:	include/linux/dma-buf* include/linux/reservation.h include/linux/*fence.h
+F:	include/linux/dma-buf*
+F:	include/linux/reservation.h
+F:	include/linux/*fence.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
-- 
1.8.1.2.459.gbcd45b4.dirty

