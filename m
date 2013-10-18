Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3JRBM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:12:28 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:49233 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JRBM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:12:26 -0400
Message-ID: <52608AE4.9060304@huawei.com>
Date: Fri, 18 Oct 2013 09:12:04 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] irq: Fix some trivial typos in comments
References: <52608AB1.1010307@huawei.com>
In-Reply-To: <52608AB1.1010307@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 kernel/irq/chip.c   |    2 +-
 kernel/irq/manage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a3bb14f..dc04c16 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -214,7 +214,7 @@ void irq_enable(struct irq_desc *desc)
 }

 /**
- * irq_disable - Mark interupt disabled
+ * irq_disable - Mark interrupt disabled
  * @desc:	irq descriptor which should be disabled
  *
  * If the chip does not implement the irq_disable callback, we
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..6394a3c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -786,7 +786,7 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 }

 /*
- * Interrupts explicitely requested as threaded interupts want to be
+ * Interrupts explicitely requested as threaded interrupts want to be
  * preemtible - many of them need to sleep and wait for slow busses to
  * complete.
  */
-- 
1.7.7



