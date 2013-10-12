Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3JLWAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 18:00:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42255 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab3JLV7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 17:59:44 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <tj@kernel.org>, <yinghai@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC 03/23] mm/memory_hotplug: remove unnecessary inclusion of bootmem.h
Date: Sat, 12 Oct 2013 17:58:46 -0400
Message-ID: <1381615146-20342-4-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
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
index ed85fe3..f7bda5e 100644
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

