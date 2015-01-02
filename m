Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbbABR4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:56:35 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:38765 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbABR4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:56:34 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Eric Biederman <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] kexec: Fix a typo in comment
Date: Fri,  2 Jan 2015 23:56:19 +0600
Message-Id: <1420221379-4553-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 9a8a01a..75a8b7e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -444,7 +444,7 @@ arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 }
 
 /*
- * Free up memory used by kernel, initrd, and comand line. This is temporary
+ * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have
  * been loaded into separate segments and have been copied elsewhere.
  */
-- 
2.2.1.202.g44ae4ee.dirty

