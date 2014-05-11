Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbaEJTzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:55:42 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41758 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaEJTzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:55:40 -0400
From: Artem Fetishev <wwctrsrx@gmail.com>
To: joe@perches.com, marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Artem Fetishev <wwctrsrx@gmail.com>
Subject: [PATCH v2 3/5] drivers: staging: ft1000: Use pr_info instead of printk
Date: Sun, 11 May 2014 10:54:22 +0300
Message-Id: <1399794864-28705-4-git-send-email-wwctrsrx@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
References: <1399794864-28705-1-git-send-email-wwctrsrx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve coding style by fixing this checkstyle warning:

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: Artem Fetishev <wwctrsrx@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a6fdd524..fd3e1a9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -24,7 +24,7 @@ struct app_info_block {
 	struct list_head app_sqlist;   /* link list of msgs for applicaton on slow queue */
 } __packed;
 
-#define DEBUG(args...) printk(KERN_INFO args)
+#define DEBUG(args...) pr_info(args)
 
 #define FALSE           0
 #define TRUE            1
-- 
1.7.10.4

