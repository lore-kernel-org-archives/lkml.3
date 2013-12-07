Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3LGNCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 08:02:39 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62794 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3LGNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 08:02:37 -0500
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 21:02:36 +0800
Message-ID: <CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com>
Subject: [PATCH -next] x86, kaslr: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, keescook@chromium.org
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/x86/boot/compressed/aslr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 84be175..90a21f4 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -10,7 +10,6 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <generated/utsrelease.h>
-#include <linux/version.h>
 
 /* Simplified build-specific string for starting entropy. */
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"

