Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3EaD0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:26:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53234 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3EaD0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:26:44 -0400
Date: Thu, 30 May 2013 20:26:18 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-83b325f1b4d00035494bc18a7a131b2197b3c718@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        bp@suse.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1369940959-2077-2-git-send-email-jacob.shin@amd.com>
References: <1369940959-2077-2-git-send-email-jacob.shin@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, intel: Correct typo in printk
Git-Commit-ID: 83b325f1b4d00035494bc18a7a131b2197b3c718
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83b325f1b4d00035494bc18a7a131b2197b3c718
Gitweb:     http://git.kernel.org/tip/83b325f1b4d00035494bc18a7a131b2197b3c718
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Thu, 30 May 2013 14:09:16 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 May 2013 20:19:25 -0700

x86, microcode, intel: Correct typo in printk

User-visible so correct it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1369940959-2077-2-git-send-email-jacob.shin@amd.com
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/microcode_intel_early.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 2e9e128..a07f0a0 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -529,7 +529,7 @@ int save_mc_for_early(u8 *mc)
 	 */
 	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
 	if (ret) {
-		pr_err("Can not save microcode patch.\n");
+		pr_err("Cannot save microcode patch.\n");
 		goto out;
 	}
 
@@ -711,7 +711,7 @@ int __init save_microcode_in_initrd(void)
 	microcode_pointer(mc_saved, mc_saved_in_initrd, initrd_start, count);
 	ret = save_microcode(&mc_saved_data, mc_saved, count);
 	if (ret)
-		pr_err("Can not save microcod patches from initrd");
+		pr_err("Cannot save microcode patches from initrd.\n");
 
 	show_saved_mc();
 
