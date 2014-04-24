Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaDXIwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaDXIwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 015/182] x86, cpufeature: Define the Intel MPX feature flag
Date: Thu, 24 Apr 2014 09:49:00 +0100
Message-Id: <1398329507-5911-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiaowei Ren <qiaowei.ren@intel.com>

commit 191f57c137bcce0e3e9313acb77b2f114d15afbb upstream.

Define the Intel MPX (Memory Protection Extensions) CPU feature flag
in the cpufeature list.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/1386375658-2191-2-git-send-email-qiaowei.ren@intel.com
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 7290585..7076d71 100644
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
-- 
1.9.1

