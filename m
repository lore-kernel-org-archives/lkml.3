Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaH2USo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:18:44 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:51704 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaH2USj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:18:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] frv: Remove unused declarations of __start___ex_table and __stop___ex_table
Date: Fri, 29 Aug 2014 22:18:33 +0200
Message-Id: <1409343516-5132-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
References: <1409343516-5132-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/frv/mm/extable.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/frv/mm/extable.c b/arch/frv/mm/extable.c
index 6aea124f574d..2fb9b3ab57b9 100644
--- a/arch/frv/mm/extable.c
+++ b/arch/frv/mm/extable.c
@@ -6,8 +6,6 @@
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
 
-extern const struct exception_table_entry __attribute__((aligned(8))) __start___ex_table[];
-extern const struct exception_table_entry __attribute__((aligned(8))) __stop___ex_table[];
 extern const void __memset_end, __memset_user_error_lr, __memset_user_error_handler;
 extern const void __memcpy_end, __memcpy_user_error_lr, __memcpy_user_error_handler;
 extern spinlock_t modlist_lock;
-- 
1.9.1

