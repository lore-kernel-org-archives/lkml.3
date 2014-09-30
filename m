Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaI3VdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:33:03 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50459 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaI3VdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:33:00 -0400
Message-ID: <542B217A.3090002@gmail.com>
Date: Tue, 30 Sep 2014 22:32:42 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Paul McQuade <paulmcquad@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: [PATCH] MM: Failslab.c use tabs where possible
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e2cfaa7895f51147addf3e08c0556a76ed6e234e Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Tue, 30 Sep 2014 22:28:08 +0100
Subject: [PATCH] MM: Failslab.c use tabs where possible

Removed code indent error

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/failslab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/failslab.c b/mm/failslab.c
index fefaaba..2064225 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -16,7 +16,7 @@ bool should_failslab(size_t size, gfp_t gfpflags, unsigned long cache_flags)
     if (gfpflags & __GFP_NOFAIL)
         return false;
 
-        if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
+    if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
         return false;
 
     if (failslab.cache_filter && !(cache_flags & SLAB_FAILSLAB))
-- 
1.9.1

