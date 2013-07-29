Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3G2E7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:59:33 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57696 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3G2E7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:59:32 -0400
MIME-Version: 1.0
Date: Mon, 29 Jul 2013 12:59:30 +0800
Message-ID: <CAPgLHd8iVmBL8838EUZLjb9kr1DEtBiaL+=pKOwBoegxDaprRA@mail.gmail.com>
Subject: [PATCH -next] staging: xillybus: remove duplicated include from xillybus_core.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, eli.billauer@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/xillybus/xillybus_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
index dd0a71c..4b216d4 100644
--- a/drivers/staging/xillybus/xillybus_core.c
+++ b/drivers/staging/xillybus/xillybus_core.c
@@ -27,11 +27,9 @@
 #include <linux/cdev.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
-#include <linux/list.h>
 #include <linux/crc32.h>
 #include <linux/poll.h>
 #include <linux/delay.h>
-#include <linux/io.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include "xillybus.h"

