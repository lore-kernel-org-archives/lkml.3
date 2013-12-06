Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab3LFSZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:25:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3LFSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:25:35 -0500
Date: Fri, 6 Dec 2013 10:25:11 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-191f57c137bcce0e3e9313acb77b2f114d15afbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, jinsong.liu@intel.com, xudong.hao@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, jinsong.liu@intel.com,
        xudong.hao@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1386375658-2191-2-git-send-email-qiaowei.ren@intel.com>
References: <1386375658-2191-2-git-send-email-qiaowei.ren@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpufeature:
  Define the Intel MPX feature flag
Git-Commit-ID: 191f57c137bcce0e3e9313acb77b2f114d15afbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 06 Dec 2013 10:25:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  191f57c137bcce0e3e9313acb77b2f114d15afbb
Gitweb:     http://git.kernel.org/tip/191f57c137bcce0e3e9313acb77b2f114d15afbb
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Sat, 7 Dec 2013 08:20:57 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 6 Dec 2013 10:21:44 -0800

x86, cpufeature: Define the Intel MPX feature flag

Define the Intel MPX (Memory Protection Extensions) CPU feature flag
in the cpufeature list.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/1386375658-2191-2-git-send-email-qiaowei.ren@intel.com
Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 89270b4..e099f95 100644
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
