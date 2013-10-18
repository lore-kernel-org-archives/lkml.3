Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3JRBNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:13:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:59475 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3JRBND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:13:03 -0400
Message-ID: <52608B0B.8060208@huawei.com>
Date: Fri, 18 Oct 2013 09:12:43 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] mm: Fix some trivial typos in comments
References: <52608AB1.1010307@huawei.com>
In-Reply-To: <52608AB1.1010307@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c3eb3d3..c9aa8d4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -955,7 +955,7 @@ static inline void slab_free_hook(struct kmem_cache *s, void *x)
 	kmemleak_free_recursive(x, s->flags);

 	/*
-	 * Trouble is that we may no longer disable interupts in the fast path
+	 * Trouble is that we may no longer disable interrupts in the fast path
 	 * So in order to make the debug calls that expect irqs to be
 	 * disabled we need to disable interrupts temporarily.
 	 */
-- 
1.7.7



