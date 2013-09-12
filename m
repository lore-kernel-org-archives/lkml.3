Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3ILDcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:32:10 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38321 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3ILDcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:32:09 -0400
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] lib: vsprintf: document formats for dentry and struct file
Date: Wed, 11 Sep 2013 20:31:26 -0700
Message-Id: <1378956686-14427-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like these were added to Documentation/printk-formats.txt but
not the in-file table.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 lib/vsprintf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..061bacb 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1218,6 +1218,8 @@ int kptr_restrict __read_mostly;
  *            The maximum supported length is 64 bytes of the input. Consider
  *            to use print_hex_dump() for the larger input.
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
+ * - 'd[234]' For a dentry name (optionally 2-4 last components)
+ * - 'D[234]' Same as 'd' but for a struct file
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
-- 
1.7.10.4

