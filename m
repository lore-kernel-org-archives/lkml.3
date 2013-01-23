Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3AWM3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 07:29:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:1547 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3AWM3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 07:29:54 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Rob Landley <rob@landley.net>, Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] PCI: Document PCI Hotplug resource reservation parameters
Date: Wed, 23 Jan 2013 20:29:06 +0800
Message-ID: <1358944146-28884-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document pci hotplug resource reservation parameters hpiosize
and hpmemsize into Documentation/kernel-parameters.txt.
The two parameters can override default hotplug io size(256 bytes)
and default mem size(2M).

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1fb269b..46eff3d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2263,6 +2263,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the default.
 				off: Turn ECRC off
 				on: Turn ECRC on.
+		hpiosize=nn[KMG]	The fixed amount of bus space which is
+				reserved for hotplug bridge's IO window.
+				Default size is 256 bytes.
+		hpmemsize=nn[KMG]	The fixed amount of bus space which is
+				reserved for hotplug bridge's memory window.
+				Default size is 2 megabytes.
 		realloc=	Enable/disable reallocating PCI bridge resources
 				if allocations done by BIOS are too small to
 				accommodate resources required by all child
-- 
1.7.1


