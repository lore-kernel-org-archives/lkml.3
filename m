Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab3DWOn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:43:27 -0400
Received: from static-87-79-237-121.netcologne.de ([87.79.237.121]:11492 "EHLO
	herc.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3DWOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:43:26 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Apr 2013 10:43:26 EDT
Message-Id: <201304231422.r3NEMhHB003395@herc.mirbsd.org>
From: Thorsten Glaser <t.glaser@tarent.de>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 23 Apr 2013 14:19:55 +0000
Subject: [PATCH] update AMD powerflags comments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from http://www.flounder.com/cpuid80000007amd.gif
and http://support.amd.com/us/Embedded_TechDocs/25481.pdf

Signed-off-by: Thorsten Glaser <t.glaser@tarent.de>
---
 arch/x86/kernel/cpu/powerflags.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
index 7b3fe56..31f0f33 100644
--- a/arch/x86/kernel/cpu/powerflags.c
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -11,10 +11,10 @@ const char *const x86_power_flags[32] = {
 	"fid",  /* frequency id control */
 	"vid",  /* voltage id control */
 	"ttp",  /* thermal trip */
-	"tm",
-	"stc",
-	"100mhzsteps",
-	"hwpstate",
+	"tm",	/* hardware thermal control */
+	"stc",	/* software thermal control */
+	"100mhzsteps", /* 100 MHz multiplier control */
+	"hwpstate", /* hardware P-state control */
 	"",	/* tsc invariant mapped to constant_tsc */
 	"cpb",  /* core performance boost */
 	"eff_freq_ro", /* Readonly aperf/mperf */
-- 
1.7.9

