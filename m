Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaD1K1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:27:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaD1K06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:26:58 -0400
Date: Mon, 28 Apr 2014 03:25:34 -0700
From: tip-bot for Randy Dunlap <tipbot@zytor.com>
Message-ID: <tip-def5f1273c5f18abf8fcaee03a115d3e907ad407@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, tglx@linutronix.de
In-Reply-To: <535DD2FD.7030804@infradead.org>
References: <535DD2FD.7030804@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] linux/interrupt.h: fix new kernel-doc warnings
Git-Commit-ID: def5f1273c5f18abf8fcaee03a115d3e907ad407
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

Commit-ID:  def5f1273c5f18abf8fcaee03a115d3e907ad407
Gitweb:     http://git.kernel.org/tip/def5f1273c5f18abf8fcaee03a115d3e907ad407
Author:     Randy Dunlap <rdunlap@infradead.org>
AuthorDate: Sun, 27 Apr 2014 21:03:09 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 28 Apr 2014 12:19:59 +0200

linux/interrupt.h: fix new kernel-doc warnings

Fix new kernel-doc warnings in <linux/interrupt.h>:

Warning(include/linux/interrupt.h:219): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:219): Excess function parameter 'mask' description in 'irq_set_affinity'
Warning(include/linux/interrupt.h:236): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:236): Excess function parameter 'mask' description in 'irq_force_affinity'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/535DD2FD.7030804@infradead.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8834a7e..97ac926 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -210,7 +210,7 @@ extern int __irq_set_affinity(unsigned int irq, const struct cpumask *cpumask,
 /**
  * irq_set_affinity - Set the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Fails if cpumask does not contain an online CPU
  */
@@ -223,7 +223,7 @@ irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 /**
  * irq_force_affinity - Force the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Same as irq_set_affinity, but without checking the mask against
  * online cpus.
