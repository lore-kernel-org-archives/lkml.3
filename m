Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3DVEj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 00:39:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55854 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3DVEj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 00:39:58 -0400
MIME-Version: 1.0
Date: Mon, 22 Apr 2013 12:39:56 +0800
Message-ID: <CAPgLHd-hTihxfc8CS2E2ZsfwFHf7oN5o4oicWOXo_dwcFhg2kA@mail.gmail.com>
Subject: [PATCH -next] ARM: vexpress: remove duplicated include from v2m.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk, pawel.moll@arm.com, rob.herring@calxeda.com,
        swarren@nvidia.com, tony@atomide.com, santosh.shilimkar@ti.com
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
 arch/arm/mach-vexpress/v2m.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index b6083bb..d07048c 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -6,7 +6,6 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
-#include <linux/clocksource.h>
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/irqchip.h>

