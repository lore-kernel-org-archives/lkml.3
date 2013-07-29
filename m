Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3G2E15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:27:57 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56850 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3G2E1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:27:54 -0400
MIME-Version: 1.0
Date: Mon, 29 Jul 2013 12:27:52 +0800
Message-ID: <CAPgLHd_SnM4M-OZ5hX-vRpvjcm4=i-LiNgTTvwQmHhmOdsaPeg@mail.gmail.com>
Subject: [PATCH -next] x86: ce4100: remove duplicated include from ce4100.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, ffainelli@freebox.fr,
        bigeasy@linutronix.de, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/x86/platform/ce4100/ce4100.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 8244f5e..d62e74d 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -15,7 +15,6 @@
 #include <linux/reboot.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_8250.h>
-#include <linux/reboot.h>
 
 #include <asm/ce4100.h>
 #include <asm/prom.h>

