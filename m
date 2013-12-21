Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3LUJX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 04:23:26 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:36369 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3LUJXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 04:23:23 -0500
MIME-Version: 1.0
Date: Sat, 21 Dec 2013 17:23:22 +0800
Message-ID: <CAPgLHd-SWJT8hXN0TPO5E-c2pGnJOOfUP-8NEOMAZBC-nJAQKw@mail.gmail.com>
Subject: [PATCH -next] misc: genwqe: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, haver@linux.vnet.ibm.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/genwqe/card_sysfs.c | 1 -
 drivers/misc/genwqe/card_base.h  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/misc/genwqe/card_sysfs.c b/drivers/misc/genwqe/card_sysfs.c
index a72a992..acd97f3 100644
--- a/drivers/misc/genwqe/card_sysfs.c
+++ b/drivers/misc/genwqe/card_sysfs.c
@@ -24,7 +24,6 @@
  * debugging, please also see the debugfs interfaces of this driver.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/module.h>

diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
index 41953e3..f034bd7 100644
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -34,7 +34,6 @@
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/version.h>
 #include <linux/debugfs.h>
 
 #include <linux/genwqe/genwqe_card.h>

