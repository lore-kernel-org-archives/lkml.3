Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaHYL0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:26:05 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:58405 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbaHYL0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:26:03 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ken Helias <kenhelias@firemail.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] list: include linux/kernel.h
Date: Mon, 25 Aug 2014 20:24:40 +0900
Message-Id: <1408965882-2983-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/list.h uses container_of, therefore it depends on
linux/kernel.h.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

I am sending this patch to LKML because I could not find
the subsystem it should belong to.
I hope I am not doing wrong.


 include/linux/list.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index cbbb96f..f33f831 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/const.h>
+#include <linux/kernel.h>
 
 /*
  * Simple doubly linked list implementation.
-- 
1.9.1

