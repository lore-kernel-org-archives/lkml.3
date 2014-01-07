Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaAGNog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:44:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38320 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAGNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:44:31 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:44:30 +0800
Message-ID: <CAPgLHd-2WadVCTbKL5gmsmAm6Rhzmy8b8rFQPCObnKMPzrqvqQ@mail.gmail.com>
Subject: [PATCH -next] drivers/rtc/rtc-isl12057.c: remove duplicated include
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/rtc/rtc-isl12057.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rtc/rtc-isl12057.c b/drivers/rtc/rtc-isl12057.c
index 7854a65..7e5ead9 100644
--- a/drivers/rtc/rtc-isl12057.c
+++ b/drivers/rtc/rtc-isl12057.c
@@ -26,7 +26,6 @@
 #include <linux/rtc.h>
 #include <linux/i2c.h>
 #include <linux/bcd.h>
-#include <linux/rtc.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/regmap.h>

