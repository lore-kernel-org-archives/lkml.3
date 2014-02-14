Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaBNEA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:00:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBNEAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:00:22 -0500
Date: Thu, 13 Feb 2014 20:00:11 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-634676c203f130c8efa138296c2efba219821346@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391845930-28580-14-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-14-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] initconst, x86:
  Fix initconst mistake in ts5500 code
Git-Commit-ID: 634676c203f130c8efa138296c2efba219821346
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:00:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  634676c203f130c8efa138296c2efba219821346
Gitweb:     http://git.kernel.org/tip/634676c203f130c8efa138296c2efba219821346
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:10 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:14:54 -0800

initconst, x86: Fix initconst mistake in ts5500 code

const data must be initconst.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-14-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/ts5500/ts5500.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/ts5500/ts5500.c b/arch/x86/platform/ts5500/ts5500.c
index 39febb2..9471b94 100644
--- a/arch/x86/platform/ts5500/ts5500.c
+++ b/arch/x86/platform/ts5500/ts5500.c
@@ -88,7 +88,7 @@ struct ts5500_sbc {
 static const struct {
 	const char * const string;
 	const ssize_t offset;
-} ts5500_signatures[] __initdata = {
+} ts5500_signatures[] __initconst = {
 	{ "TS-5x00 AMD Elan", 0xb14 },
 };
 
