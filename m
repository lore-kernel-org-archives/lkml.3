Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbaEPNhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:37:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54326 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbaEPNhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:37:39 -0400
Date: Fri, 16 May 2014 06:36:42 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-5fdaf1bf8a60f73a11cb4431fd06daa2b295a327@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, schwidefsky@de.ibm.com, peterz@infradead.org,
        tony.luck@intel.com, heiko.carstens@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        schwidefsky@de.ibm.com, tony.luck@intel.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20140507154339.609149081@linutronix.de>
References: <20140507154339.609149081@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] s390: Remove pointless arch_show_interrupts()
Git-Commit-ID: 5fdaf1bf8a60f73a11cb4431fd06daa2b295a327
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

Commit-ID:  5fdaf1bf8a60f73a11cb4431fd06daa2b295a327
Gitweb:     http://git.kernel.org/tip/5fdaf1bf8a60f73a11cb4431fd06daa2b295a327
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:22 +0200

s390: Remove pointless arch_show_interrupts()

S390 is not using the generic show interrupts implementation so the
extra arch_show_interrupts() is just useless.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Link: http://lkml.kernel.org/r/20140507154339.609149081@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/kernel/irq.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index c7463aa..2fb0998 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -151,11 +151,6 @@ out:
 	return 0;
 }
 
-int arch_show_interrupts(struct seq_file *p, int prec)
-{
-	return 0;
-}
-
 /*
  * Switch to the asynchronous interrupt stack for softirq execution.
  */
