Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaGJT3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:29:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:37474 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaGJT3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:29:46 -0400
Message-ID: <1405020576.4264.14.camel@smoke>
Subject: [PATCH] include: Minor comment fix in generic.h
From: Geoff Levand <geoff@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jul 2014 12:29:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geoff Levand <geoff@infradead.org>
---

Hi Andrew,

Just a very minor comment fix.  Please consider.

-Geoff

 include/linux/byteorder/generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 0846e6b..89f67c1 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
@@ -2,7 +2,7 @@
 #define _LINUX_BYTEORDER_GENERIC_H
 
 /*
- * linux/byteorder_generic.h
+ * linux/byteorder/generic.h
  * Generic Byte-reordering support
  *
  * The "... p" macros, like le64_to_cpup, can be used with pointers
-- 
1.9.1



