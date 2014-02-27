Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaB0MeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:34:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaB0MeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:34:03 -0500
Date: Thu, 27 Feb 2014 04:33:29 -0800
From: tip-bot for Rashika Kheria <tipbot@zytor.com>
Message-ID: <tip-64be38ab03e9b238a1299857fef8b3707c0ed045@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, rashika.kheria@gmail.com, hpa@zytor.com,
        mingo@kernel.org, benh@kernel.crashing.org, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, rashika.kheria@gmail.com,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <eb89aebea7ff1a46122918ac389ebecf8248be9a.1393493276.git.rashika.kheria@gmail.com>
References: <eb89aebea7ff1a46122918ac389ebecf8248be9a.1393493276.git.rashika.kheria@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Include missing header file in irqdomain.c
Git-Commit-ID: 64be38ab03e9b238a1299857fef8b3707c0ed045
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

Commit-ID:  64be38ab03e9b238a1299857fef8b3707c0ed045
Gitweb:     http://git.kernel.org/tip/64be38ab03e9b238a1299857fef8b3707c0ed045
Author:     Rashika Kheria <rashika.kheria@gmail.com>
AuthorDate: Thu, 27 Feb 2014 17:10:12 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 27 Feb 2014 13:29:35 +0100

genirq: Include missing header file in irqdomain.c

Include appropriate header file include/linux/of_irq.h in
kernel/irq/irqdomain.c because it contains prototype definition of
function define in kernel/irq/irqdomain.c.

This eliminates the following warning in kernel/irq/irqdomain.c:
kernel/irq/irqdomain.c:468:14: warning: no previous prototype for ‘irq_create_of_mapping’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/eb89aebea7ff1a46122918ac389ebecf8248be9a.1393493276.git.rashika.kheria@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdomain.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cf68bb3..f140337 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -10,6 +10,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/topology.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
