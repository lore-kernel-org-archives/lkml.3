Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3HVJpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:45:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18787 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3HVJpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:45:07 -0400
Message-ID: <5215DD14.4010605@huawei.com>
Date: Thu, 22 Aug 2013 17:42:44 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <rob@landley.net>, <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm/hotplug: fix a trivial typo in Documentation/memory-hotplug.txt
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial typo in Documentation/memory-hotplug.txt

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 Documentation/memory-hotplug.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 8e5eacb..d7a9b0a 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -163,7 +163,7 @@ a recent addition and not present on older kernels.
                     at read:  contains online/offline state of memory.
                     at write: user can specify "online_kernel",
                     "online_movable", "online", "offline" command
-                    which will be performed on al sections in the block.
+                    which will be performed on all sections in the block.
 'phys_device'     : read-only: designed to show the name of physical memory
                     device.  This is not well implemented now.
 'removable'       : read-only: contains an integer value indicating
-- 
1.7.1


