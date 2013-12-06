Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3LFLhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:37:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:15156 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771Ab3LFLhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:37:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,840,1378882800"; 
   d="scan'208";a="326052929"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: [PATCH 2/3] X86, mpx: Intel MPX definition
Date: Sat,  7 Dec 2013 02:52:55 +0800
Message-Id: <1386355976-11732-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
---
 arch/x86/include/asm/cpufeature.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index d3f5c63..6c2738d 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -216,6 +216,7 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
@@ -330,6 +331,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_perfctr_l2	boot_cpu_has(X86_FEATURE_PERFCTR_L2)
 #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
 #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
+#define cpu_has_mpx		boot_cpu_has(X86_FEATURE_MPX)
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-- 
1.7.1

