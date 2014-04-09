Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbaDIWLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 18:11:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38948 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934430AbaDIWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 18:11:23 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: ajk@comnets.uni-bremen.de
Cc: linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net:hamradio:6pack.c:#include <linux/uaccess.h>
Date: Wed,  9 Apr 2014 23:11:08 +0100
Message-Id: <1397081468-10301-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/net/hamradio/6pack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 66e2b19..4cd3acd 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -13,7 +13,7 @@
  */
 
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-- 
1.8.3.2

