Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3J3Fig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:38:36 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:61728 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3J3Fif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:38:35 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 13:38:34 +0800
Message-ID: <CAPgLHd9smv2Jcb7SUxKsXHqnDos53A3ZhVWPMSyDJckR9_URKQ@mail.gmail.com>
Subject: [PATCH -next] ARM i.MX53: remove duplicated include from clk-imx51-imx53.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-imx/clk-imx51-imx53.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index ce37af2..2828ea65 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -12,7 +12,6 @@
 #include <linux/io.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
-#include <linux/of.h>
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/of_address.h>

