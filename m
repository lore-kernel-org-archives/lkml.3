Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3KGFv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:51:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45717 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab3KGFvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:53 -0500
Message-ID: <527B2A76.2000501@infradead.org>
Date: Wed, 06 Nov 2013 21:51:50 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        lailavrazda1979@gmail.com
Subject: [PATCH] kcore: add Kconfig help text
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Under Pseudo filesystems, /proc/kcore support has no help,
so add some.

Fixes a portion of kernel bugzilla #52671:
  https://bugzilla.kernel.org/show_bug.cgi?id=52671

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: lailavrazda1979@gmail.com
---
Would anyone like to expand on this help text?
Thanks.

 fs/proc/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-312.orig/fs/proc/Kconfig
+++ lnx-312/fs/proc/Kconfig
@@ -31,6 +31,8 @@ config PROC_FS
 config PROC_KCORE
 	bool "/proc/kcore support" if !ARM
 	depends on PROC_FS && MMU
+	help
+	  Exports kernel core in ELF format.
 
 config PROC_VMCORE
 	bool "/proc/vmcore support"
