Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739AbaDJSxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:53:22 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50934 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889AbaDJSxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:53:21 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz
Subject: [PATCH 10/15] kernel:acct:<linux/uaccess.h
Date: Thu, 10 Apr 2014 19:53:18 +0100
Message-Id: <1397155998-6789-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 8d6e145..df28519 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -55,7 +55,7 @@
 #include <linux/times.h>
 #include <linux/syscalls.h>
 #include <linux/mount.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/div64.h>
 #include <linux/blkdev.h> /* sector_div */
 #include <linux/pid_namespace.h>
-- 
1.8.3.2

