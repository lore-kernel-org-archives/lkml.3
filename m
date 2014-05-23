Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaEWVQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:16:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:28193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaEWVP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:15:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,896,1392192000"; 
   d="scan'208";a="545726188"
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] Pass on hwpoison maintainership to Naoya Noriguchi
Date: Fri, 23 May 2014 14:15:39 -0700
Message-Id: <1400879739-12614-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Noriguchi-san has done most of the work on hwpoison in the last years
and he also does most of the reviewing. So I'm passing on the hwpoison
maintainership to him.

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c596b74..e84d510 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4017,9 +4017,8 @@ S:	Odd Fixes
 F:	drivers/media/usb/hdpvr/
 
 HWPOISON MEMORY FAILURE HANDLING
-M:	Andi Kleen <andi@firstfloor.org>
+M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
 L:	linux-mm@kvack.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison
 S:	Maintained
 F:	mm/memory-failure.c
 F:	mm/hwpoison-inject.c
-- 
1.9.0

