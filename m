Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbaDJSsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:48:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52798 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965773AbaDJSsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:48:37 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 05/15] ipc:shm.c:<linux/uaccess.h
Date: Thu, 10 Apr 2014 19:48:33 +0100
Message-Id: <1397155713-6531-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 ipc/shm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index 7645961..89ab12c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -43,7 +43,7 @@
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "util.h"
 
-- 
1.8.3.2

