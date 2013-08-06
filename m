Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3HFVo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HFVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:26 -0400
Date: Tue, 6 Aug 2013 14:44:12 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-54c2f3fdb941204cad136024c7b854b7ad112ab6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-12-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-12-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, apm:
  Make APM data structure used from assembler visible
Git-Commit-ID: 54c2f3fdb941204cad136024c7b854b7ad112ab6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54c2f3fdb941204cad136024c7b854b7ad112ab6
Gitweb:     http://git.kernel.org/tip/54c2f3fdb941204cad136024c7b854b7ad112ab6
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:20:20 -0700

x86, asmlinkage, apm: Make APM data structure used from assembler visible

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-12-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apm_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 53a4e27..3ab0343 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -392,7 +392,7 @@ static struct cpuidle_device apm_cpuidle_device;
 /*
  * Local variables
  */
-static struct {
+__visible struct {
 	unsigned long	offset;
 	unsigned short	segment;
 } apm_bios_entry;
