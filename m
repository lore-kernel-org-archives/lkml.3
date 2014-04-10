Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbaDJSzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:55:40 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41691 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbaDJSzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:55:35 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com
Subject: [PATCH 14/15] kernel:audit:<linux/types.h>
Date: Thu, 10 Apr 2014 19:55:32 +0100
Message-Id: <1397156132-6981-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/types.h> instead of <asm/types.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 95a20f3..1ef36a4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -44,7 +44,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/atomic.h>
 #include <linux/mm.h>
 #include <linux/export.h>
-- 
1.8.3.2

