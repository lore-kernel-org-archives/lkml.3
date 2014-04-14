Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDNB7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:59:53 -0400
Received: from smtprelay0126.hostedemail.com ([216.40.44.126]:43329 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754510AbaDNB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:56:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3868:3871:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shelf04_5618bb6a6ea51
X-Filterd-Recvd-Size: 1541
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 3.16 12/19] inotify: Convert use of typedef ctl_table to struct ctl_table
Date: Sun, 13 Apr 2014 18:55:44 -0700
Message-Id: <f07d31ad375c957ba59f0f3ca3750959adef3b5e.1397438826.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1397438826.git.joe@perches.com>
References: <cover.1397438826.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 78a2ca3..cc423a3 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -57,7 +57,7 @@ static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
 
 static int zero;
 
-ctl_table inotify_table[] = {
+struct ctl_table inotify_table[] = {
 	{
 		.procname	= "max_user_instances",
 		.data		= &inotify_max_user_instances,
-- 
1.8.1.2.459.gbcd45b4.dirty

