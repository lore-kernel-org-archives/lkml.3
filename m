Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3LCC3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:29:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53773 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3LCC3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:29:08 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 04/23] mm/memory_hotplug: remove unnecessary inclusion of bootmem.h
Date: Mon, 2 Dec 2013 21:27:19 -0500
Message-ID: <1386037658-3161-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Clean-up to remove depedency with bootmem headers.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/memory_hotplug.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 489f235..cf1736d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -9,7 +9,6 @@
 #include <linux/swap.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
-#include <linux/bootmem.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/pagevec.h>
-- 
1.7.9.5

