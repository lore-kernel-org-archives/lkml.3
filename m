Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaKPUJu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:50 -0500
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:41751 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242AbaKPUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1431:1434:1437:1534:1539:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:5007:6261:10004:10848:11026:11473:11658:11914:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat87_556558385e912
X-Filterd-Recvd-Size: 1525
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 09/16] signal: Use include <linux not <asm
Date: Sun, 16 Nov 2014 12:09:16 -0800
Message-Id: <c6fc50e39f8916b74cd07a1685cc3191f16b84c0.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more common include path.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index ccd57a3..74bd4dd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -36,12 +36,12 @@
 #include <linux/compat.h>
 #include <linux/cn_proc.h>
 #include <linux/compiler.h>
+#include <linux/uaccess.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
 
 #include <asm/param.h>
-#include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/siginfo.h>
 #include <asm/cacheflush.h>
-- 
2.1.2

