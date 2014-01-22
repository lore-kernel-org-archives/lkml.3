Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaAVWdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:33:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaAVWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:33:35 -0500
Date: Wed, 22 Jan 2014 14:33:25 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-48102ca7fb2856dde2c75fbd37db45ba630f2967@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1390429369-13761-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1390429369-13761-1-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid: Add missing 'void'
  to functions without arguments
Git-Commit-ID: 48102ca7fb2856dde2c75fbd37db45ba630f2967
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 22 Jan 2014 14:33:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  48102ca7fb2856dde2c75fbd37db45ba630f2967
Gitweb:     http://git.kernel.org/tip/48102ca7fb2856dde2c75fbd37db45ba630f2967
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Wed, 22 Jan 2014 14:22:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Jan 2014 14:30:02 -0800

x86, intel-mid: Add missing 'void' to functions without arguments

This patch adds missing 'void' to functions that doesn't receive
arguments.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1390429369-13761-1-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/mfld.c | 6 +++---
 arch/x86/platform/intel-mid/mrfl.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
index 88b06fc..23381d2 100644
--- a/arch/x86/platform/intel-mid/mfld.c
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -58,18 +58,18 @@ static unsigned long __init mfld_calibrate_tsc(void)
 	return 0;
 }
 
-static void __init penwell_arch_setup()
+static void __init penwell_arch_setup(void)
 {
 	x86_platform.calibrate_tsc = mfld_calibrate_tsc;
 	pm_power_off = mfld_power_off;
 }
 
-void *get_penwell_ops()
+void *get_penwell_ops(void)
 {
 	return &penwell_ops;
 }
 
-void *get_cloverview_ops()
+void *get_cloverview_ops(void)
 {
 	return &penwell_ops;
 }
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
index 28b636a..aaca917 100644
--- a/arch/x86/platform/intel-mid/mrfl.c
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -97,7 +97,7 @@ static struct intel_mid_ops tangier_ops = {
 	.arch_setup = tangier_arch_setup,
 };
 
-void *get_tangier_ops()
+void *get_tangier_ops(void)
 {
 	return &tangier_ops;
 }
