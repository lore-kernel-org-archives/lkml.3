Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab3FNCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:42:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54582 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759632Ab3FNCmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:42:15 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 27/33] key: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:52 -0700
Message-Id: <022a6fa5a123e17c1394fc30539dd32f12345329.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/key.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 4dfde11..3b98ce0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -310,7 +310,7 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern struct ctl_table key_sysctls[];
 #endif
 /*
  * the userspace interface
-- 
1.8.1.2.459.gbcd45b4.dirty

