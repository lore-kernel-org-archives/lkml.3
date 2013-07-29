Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3G2E2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:28:54 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59342 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3G2E2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:28:53 -0400
MIME-Version: 1.0
Date: Mon, 29 Jul 2013 12:28:51 +0800
Message-ID: <CAPgLHd-VyRHaH0b-DvJO1zv68RWHKGc8F9cwZdJqRWD9HO1QVA@mail.gmail.com>
Subject: [PATCH -next] staging: comedi: dt9812: remove duplicated include from dt9812.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com
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
 drivers/staging/comedi/drivers/dt9812.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index ffb7572..b865367 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -42,7 +42,6 @@ for my needs.
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 

