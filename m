Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbaDJSpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:45:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35825 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaDJSp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:45:29 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com
Subject: [PATCH 03/15] ipc:sem.c #include <linux/uaccess.h>
Date: Thu, 10 Apr 2014 19:45:25 +0100
Message-Id: <1397155525-6420-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index bee5554..3bbfa6c 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -87,7 +87,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "util.h"
 
 /* One semaphore structure for each semaphore in the system. */
-- 
1.8.3.2

