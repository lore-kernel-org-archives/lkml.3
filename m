Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935847Ab3IEM07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:26:59 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:42848 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713Ab3IEM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:26:58 -0400
Message-ID: <5228786E.1030501@huawei.com>
Date: Thu, 5 Sep 2013 20:26:22 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <benh@kernel.crashing.org>, <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] doc: fix some typos in documentation
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in Documentation/IRQ-domain.txt/email-clients.txt/io-mapping.txt

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/IRQ-domain.txt    |    4 ++--
 Documentation/email-clients.txt |    2 +-
 Documentation/io-mapping.txt    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/IRQ-domain.txt b/Documentation/IRQ-domain.txt
index 9bc9594..5a8b8ed 100644
--- a/Documentation/IRQ-domain.txt
+++ b/Documentation/IRQ-domain.txt
@@ -97,7 +97,7 @@ hwirq number.  The disadvantage is that hwirq to IRQ number lookup is
 dependent on how many entries are in the table.
 
 Very few drivers should need this mapping.  At the moment, powerpc
-iseries is the only user.
+series is the only user.
 
 ==== No Map ===-
 irq_domain_add_nomap()
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
 
-- 
1.7.1


