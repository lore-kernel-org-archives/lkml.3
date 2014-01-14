Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaANSsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:48:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaANSss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:48:48 -0500
Date: Tue, 14 Jan 2014 10:48:26 -0800
From: tip-bot for Wei Yongjun <tipbot@zytor.com>
Message-ID: <tip-19259943f0954dcd1817f94776376bf51c6a46d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, yongjun_wei@trendmicro.com.cn,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com>
References: <CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: Remove unused including <linux/
 version.h>
Git-Commit-ID: 19259943f0954dcd1817f94776376bf51c6a46d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 10:48:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19259943f0954dcd1817f94776376bf51c6a46d5
Gitweb:     http://git.kernel.org/tip/19259943f0954dcd1817f94776376bf51c6a46d5
Author:     Wei Yongjun <yongjun_wei@trendmicro.com.cn>
AuthorDate: Sat, 7 Dec 2013 21:02:36 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 14 Jan 2014 10:45:56 -0800

x86, kaslr: Remove unused including <linux/version.h>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Link: http://lkml.kernel.org/r/CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
