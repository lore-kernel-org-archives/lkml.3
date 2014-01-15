Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaAOL17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:27:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:52772 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAOL14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:27:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,662,1384329600"; 
   d="scan'208";a="439169920"
From: Ren Qiaowei <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ren Qiaowei <qiaowei.ren@intel.com>
Subject: [PATCH 1/1] x86: remove extra space in structure for consistency
Date: Wed, 15 Jan 2014 12:25:25 +0800
Message-Id: <1389759925-10370-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra space before x86_max_cores member in struct cpuinfo_x86
for consistency.

Signed-off-by: Ren Qiaowei <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4..d22797b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -113,7 +113,7 @@ struct cpuinfo_x86 {
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
 	/* cpuid returned max cores value: */
-	u16			 x86_max_cores;
+	u16			x86_max_cores;
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
-- 
1.8.1.2

