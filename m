Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3ENIxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:53:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab3ENIxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:53:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,669,1363104000"; 
   d="scan'208";a="7265084"
Message-ID: <5191FAE2.4020403@cn.fujitsu.com>
Date: Tue, 14 May 2013 16:50:42 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, 64bit: Drop unneeded include <asm/{pgtable, page}_types.h>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 16:51:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 16:51:54,
	Serialize complete at 2013/05/14 16:51:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/boot/compressed/head_64.S includes <asm/pgtable_types.h>
and <asm/page_types.h> but it doesn't look like it needs them.
So remove them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/boot/compressed/head_64.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 16f24e6..06e71c2 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -27,8 +27,6 @@
 #include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
-#include <asm/pgtable_types.h>
-#include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/msr.h>
 #include <asm/processor-flags.h>
-- 
1.7.1
