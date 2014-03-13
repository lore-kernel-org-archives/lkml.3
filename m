Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaCMWhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:37:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaCMWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:37:17 -0400
Date: Thu, 13 Mar 2014 15:37:03 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-b82ad3d3944193e5f95319c30fd24e39d0d7b510@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1394633584-5509-4-git-send-email-bp@alien8.de>
References: <1394633584-5509-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, pageattr:
  Correct WBINVD spelling in comment
Git-Commit-ID: b82ad3d3944193e5f95319c30fd24e39d0d7b510
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

Commit-ID:  b82ad3d3944193e5f95319c30fd24e39d0d7b510
Gitweb:     http://git.kernel.org/tip/b82ad3d3944193e5f95319c30fd24e39d0d7b510
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 12 Mar 2014 15:13:04 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 15:32:45 -0700

x86, pageattr: Correct WBINVD spelling in comment

It is WBINVD, for INValiDate and not "wbindv". Use caps for instruction
names, while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394633584-5509-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pageattr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f4..ba957c9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1377,10 +1377,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cache = cache_attr(mask_set);
 
 	/*
-	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it and in the
+	 * On success we use CLFLUSH, when the CPU supports it to
+	 * avoid the WBINVD. If the CPU does not support it and in the
 	 * error case we fall back to cpa_flush_all (which uses
-	 * wbindv):
+	 * WBINVD):
 	 */
 	if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
