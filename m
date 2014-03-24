Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaCXHV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:21:57 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40624 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaCXHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:21:55 -0400
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Sitnicki <jsitnicki@gmail.com>
Subject: [PATCH 1/2] ext2: acl: remove unneeded include of linux/capability.h
Date: Mon, 24 Mar 2014 08:21:24 +0100
Message-Id: <1395645684-26512-1-git-send-email-jsitnicki@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acl.c has not been (directly) using the interface defined by
linux/capability.h header since commit 3bd858ab1c451725c07a
("Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid
check"). Remove it.

Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
---
 fs/ext2/acl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 1b8001b..27695e6 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -4,7 +4,6 @@
  * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  */
 
-#include <linux/capability.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-- 
1.8.5.3

