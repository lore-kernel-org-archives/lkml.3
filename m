Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3CDDsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:48:15 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:51005 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab3CDDsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:48:11 -0500
From: Hanjun Guo <guohanjun@huawei.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
CC: <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 1/2] ia64: iosapic: fix a minor typo in comments
Date: Mon, 4 Mar 2013 11:46:48 +0800
Message-ID: <1362368808-28996-1-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.10.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.124]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

describeinterrupts -> describe interrupts

Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 arch/ia64/kernel/iosapic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index ee33c3a..a6e2f75 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -76,7 +76,7 @@
  *	PCI pin -> global system interrupt (GSI) -> IA-64 vector <-> IRQ
  *
  * Note: The term "IRQ" is loosely used everywhere in Linux kernel to
- * describeinterrupts.  Now we use "IRQ" only for Linux IRQ's.  ISA IRQ
+ * describe interrupts.  Now we use "IRQ" only for Linux IRQ's.  ISA IRQ
  * (isa_irq) is the only exception in this source code.
  */
 
-- 
1.6.0.2


