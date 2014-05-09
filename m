Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaEIXn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:43:26 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:53663 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756802AbaEIXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:43:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3876:3877:4321:5007:6114:6261:6642:9592:10004:10026:10848:11026:11473:11638:11657:11658:11914:12043:12296:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: joke96_917f7c576e839
X-Filterd-Recvd-Size: 1776
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 2/4] UserModeLinux: Remove unused #defines of UM_KERN_<LEVEL>
Date: Fri,  9 May 2014 16:43:11 -0700
Message-Id: <a0f82001821248eeccf32d1032a17b2d3b1f0add.1399678795.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1399678795.git.joe@perches.com>
References: <cover.1399678795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are now unused so delete them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/include/shared/user.h | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index cef0685..4fa82c0 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -26,17 +26,6 @@
 extern void panic(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 
-/* Requires preincluding include/linux/kern_levels.h */
-#define UM_KERN_EMERG	KERN_EMERG
-#define UM_KERN_ALERT	KERN_ALERT
-#define UM_KERN_CRIT	KERN_CRIT
-#define UM_KERN_ERR	KERN_ERR
-#define UM_KERN_WARNING	KERN_WARNING
-#define UM_KERN_NOTICE	KERN_NOTICE
-#define UM_KERN_INFO	KERN_INFO
-#define UM_KERN_DEBUG	KERN_DEBUG
-#define UM_KERN_CONT	KERN_CONT
-
 #ifdef UML_CONFIG_PRINTK
 extern int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
-- 
1.8.1.2.459.gbcd45b4.dirty

