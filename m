Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaBIWtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:49:04 -0500
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:35672 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369AbaBIWtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:49:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3622:3865:3867:3871:3872:4250:4321:5007:6261:9592:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sugar77_143eea4dfd720
X-Filterd-Recvd-Size: 1340
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ncpfs: Remove now unused PRINTK macro
Date: Sun,  9 Feb 2014 14:48:48 -0800
Message-Id: <cd71e72f826219809c86806763c8420f41bc8348.1391985629.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1391985629.git.joe@perches.com>
References: <cover.1391985629.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses are gone, remove the macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ncpfs/ncp_fs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ncpfs/ncp_fs.h b/fs/ncpfs/ncp_fs.h
index f38134e..6e9a507 100644
--- a/fs/ncpfs/ncp_fs.h
+++ b/fs/ncpfs/ncp_fs.h
@@ -2,9 +2,6 @@
 #include "ncp_fs_i.h"
 #include "ncp_fs_sb.h"
 
-/* define because it is easy to change PRINTK to {*}PRINTK */
-#define PRINTK(format, args...) printk(KERN_DEBUG format , ## args)
-
 #undef NCPFS_PARANOIA
 #ifdef NCPFS_PARANOIA
 #define ncp_vdbg(fmt, ...)					\
-- 
1.8.1.2.459.gbcd45b4.dirty

