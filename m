Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3IPBvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 21:51:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:56793 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3IPBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 21:51:42 -0400
Message-ID: <5236641B.1090509@huawei.com>
Date: Mon, 16 Sep 2013 09:51:23 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <benh@kernel.crashing.org>, <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Xishi Qiu <qiuxishi@huawei.com>,
        "Randy Dunlap" <rdunlap@infradead.org>
Subject: [PATCH v2] doc: fix some typos
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in three documentations.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/IRQ-domain.txt    |    2 +-
 Documentation/email-clients.txt |    2 +-
 Documentation/io-mapping.txt    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
 
-- 
1.7.1


