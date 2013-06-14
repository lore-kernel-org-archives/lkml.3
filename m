Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3FNClX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:41:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49822 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759888Ab3FNClV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:41:21 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 21/33] inotify: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:46 -0700
Message-Id: <8144f4dd104d4b22ed3354851ca9da1a5313813f.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/notify/inotify/inotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 959815c..3e03d81 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -58,7 +58,7 @@ struct kmem_cache *event_priv_cachep __read_mostly;
 
 static int zero;
 
-ctl_table inotify_table[] = {
+struct ctl_table inotify_table[] = {
 	{
 		.procname	= "max_user_instances",
 		.data		= &inotify_max_user_instances,
-- 
1.8.1.2.459.gbcd45b4.dirty

