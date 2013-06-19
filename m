Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935354Ab3FSXoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:44:09 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51450 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:44:08 -0400
MIME-Version: 1.0
Date: Thu, 20 Jun 2013 07:44:05 +0800
Message-ID: <CAPgLHd9-sZkf8CboY9noao0GnSRRFsRCtnU0C0mtmKJRRFaC-Q@mail.gmail.com>
Subject: [PATCH -next] arm: remove duplicated include from process.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk, akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        tglx@linutronix.de, holt@sgi.com
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
 arch/arm/kernel/process.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 7591df5..f89ff80 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -32,7 +32,6 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/cpuidle.h>
 #include <linux/leds.h>
-#include <linux/reboot.h>
 
 #include <asm/cacheflush.h>
 #include <asm/idmap.h>

