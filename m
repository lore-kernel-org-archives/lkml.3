Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3INDuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 23:50:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:6355 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3INDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 23:50:16 -0400
Message-ID: <5233DCD1.4010006@huawei.com>
Date: Sat, 14 Sep 2013 11:49:37 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <benh@kernel.crashing.org>, <rob@landley.net>, <ananth@in.ibm.com>,
        <anil.s.keshavamurthy@intel.com>, <davem@davemloft.net>,
        <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc: fix some typos
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in documentation.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/IRQ-domain.txt    |    2 +-
 Documentation/email-clients.txt |    2 +-
 Documentation/io-mapping.txt    |    2 +-
 Documentation/kprobes.txt       |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 9bc9594..03df71a 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -141,7 +141,7 @@ will use a legacy domain only if an IRQ range is supplied by the
 system and will otherwise use a linear domain mapping. The semantics
 of this call are such that if an IRQ range is specified then
 descriptors will be allocated on-the-fly for it, and if no range is
-specified it will fall through to irq_domain_add_linear() which meand
+specified it will fall through to irq_domain_add_linear() which means
 *no* irq descriptors will be allocated.
 
 A typical use case for simple domains is where an irqchip provider
diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 860c29a..e9f5dac 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -104,7 +104,7 @@ Then from the "Message" menu item, select insert file and choose your patch.
 As an added bonus you can customise the message creation toolbar menu
 and put the "insert file" icon there.
 
-Make the the composer window wide enough so that no lines wrap. As of
+Make the composer window wide enough so that no lines wrap. As of
 KMail 1.13.5 (KDE 4.5.4), KMail will apply word wrapping when sending
 the email if the lines wrap in the composer window. Having word wrapping
 disabled in the Options menu isn't enough. Thus, if your patch has very
diff --git a/Documentation/io-mapping.txt b/Documentation/io-mapping.txt
index 473e43b..5ca7842 100644
--- a/Documentation/io-mapping.txt
+++ b/Documentation/io-mapping.txt
@@ -38,7 +38,7 @@ maps are more efficient:
 
 	void io_mapping_unmap_atomic(void *vaddr)
 
-		'vaddr' must be the the value returned by the last
+		'vaddr' must be the value returned by the last
 		io_mapping_map_atomic_wc call. This unmaps the specified
 		page and allows the task to sleep once again.
 
diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..ca278d5 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -92,7 +92,7 @@ stack contents as the probed function.  When it is done, the handler
 calls jprobe_return(), which traps again to restore the original stack
 contents and processor state and switch to the probed function.
 
-By convention, the callee owns its arguments, so gcc may produce code
+By convention, the caller owns its arguments, so gcc may produce code
 that unexpectedly modifies that portion of the stack.  This is why
 Kprobes saves a copy of the stack and restores it after the jprobe
 handler has run.  Up to MAX_STACK_SIZE bytes are copied -- e.g.,
-- 
1.7.1


