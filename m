Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaHHPPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:15:24 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53639 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbaHHPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:15:23 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial] mm: Fix CROSS_MEMORY_ATTACH help text grammar
Date: Fri,  8 Aug 2014 17:15:14 +0200
Message-Id: <1407510914-5151-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index a291b7ef4738..5aec7006c8bb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -268,7 +268,7 @@ config CROSS_MEMORY_ATTACH
 	help
 	  Enabling this option adds the system calls process_vm_readv and
 	  process_vm_writev which allow a process with the correct privileges
-	  to directly read from or write to to another process's address space.
+	  to directly read from or write to another process' address space.
 	  See the man page for more details.
 
 config FHANDLE
-- 
1.9.1

