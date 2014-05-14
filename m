Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaENTP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:15:28 -0400
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:50063 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752725AbaENTPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:15:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3876:3877:4321:5007:6114:6261:6642:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glue17_8614cfbcb425f
X-Filterd-Recvd-Size: 1857
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] wlcore: Remove trailing semicolon from do {...} while (0) macro
Date: Wed, 14 May 2014 12:15:14 -0700
Message-Id: <a62dbcaa8438b3ee6cdf94d7681427c6f48f122a.1400094804.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1400094804.git.joe@perches.com>
References: <cover.1400094804.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should not have trailing semicolons so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index f7381dd..0f2cfb0 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -57,7 +57,7 @@ static const struct file_operations name## _ops = {			\
 					    wl, &name## _ops);		\
 		if (!entry || IS_ERR(entry))				\
 			goto err;					\
-	} while (0);
+	} while (0)
 
 
 #define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
@@ -66,7 +66,7 @@ static const struct file_operations name## _ops = {			\
 				    wl, &prefix## _## name## _ops);	\
 		if (!entry || IS_ERR(entry))				\
 			goto err;					\
-	} while (0);
+	} while (0)
 
 #define DEBUGFS_FWSTATS_FILE(sub, name, fmt, struct_type)		\
 static ssize_t sub## _ ##name## _read(struct file *file,		\
-- 
1.8.1.2.459.gbcd45b4.dirty

