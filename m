Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3LETeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:34:15 -0500
Received: from qemu.weilnetz.de ([37.221.198.45]:57603 "EHLO
	v2201305906712890.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761Ab3LETeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:34:12 -0500
From: Stefan Weil <sw@weilnetz.de>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Stefan Weil <sw@weilnetz.de>,
        Jiri Kosina <trivial@kernel.org>, Rob Landley <rob@landley.net>
Subject: [PATCH] Documentation: Fix typo (acces_process_vm -> access_process_vm)
Date: Thu,  5 Dec 2013 20:34:05 +0100
Message-Id: <1386272045-3408-1-git-send-email-sw@weilnetz.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Stefan Weil <sw@weilnetz.de>
---
 Documentation/filesystems/Locking |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fe7afe2..5b0c083 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -544,7 +544,7 @@ like the ->fault() handler, but simply return with VM_FAULT_NOPAGE, which
 will cause the VM to retry the fault.
 
 	->access() is called when get_user_pages() fails in
-acces_process_vm(), typically used to debug a process through
+access_process_vm(), typically used to debug a process through
 /proc/pid/mem or ptrace.  This function is needed only for
 VM_IO | VM_PFNMAP VMAs.
 
-- 
1.7.10.4

