Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935422AbaDJSmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:42:46 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51846 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbaDJSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:42:44 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: npajkovs@redhat.com, akpm@linux-foundation.org, heiko.carstens@de.ibm.com
Subject: [PATCH 01/15] ipc:#include <linux/uaccess.h>
Date: Thu, 10 Apr 2014 19:42:40 +0100
Message-Id: <1397155360-6304-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/compat.c    | 2 +-
 ipc/compat_mq.c | 2 +-
 ipc/msg.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 45d035d..b5ef4f7 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -30,7 +30,7 @@
 #include <linux/ptrace.h>
 
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index 90d29f5..ef6f91c 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -12,7 +12,7 @@
 #include <linux/mqueue.h>
 #include <linux/syscalls.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 struct compat_mq_attr {
 	compat_long_t mq_flags;      /* message queue flags		     */
diff --git a/ipc/msg.c b/ipc/msg.c
index 6498531..a385372 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -39,7 +39,7 @@
 #include <linux/ipc_namespace.h>
 
 #include <asm/current.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /*
-- 
1.8.3.2

