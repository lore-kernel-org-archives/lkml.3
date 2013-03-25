Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab3CYUNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:13:34 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:50634 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932801Ab3CYUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:13:33 -0400
Message-ID: <1364242347.1390.294.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Some header guard comments are contagious
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 21:12:27 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 20:12:27.0000 (UTC) FILETIME=[120C8780:01CE2995]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Bravely untested. 

 include/linux/evm.h       | 2 +-
 include/linux/ima.h       | 4 ++--
 include/linux/integrity.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 9fc13a7..1fcb88c 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -96,5 +96,5 @@ static inline int evm_inode_init_security(struct inode *inode,
 	return 0;
 }
 
-#endif /* CONFIG_EVM_H */
+#endif /* CONFIG_EVM */
 #endif /* LINUX_EVM_H */
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 86c361e..1b7f268 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -46,7 +46,7 @@ static inline int ima_module_check(struct file *file)
 	return 0;
 }
 
-#endif /* CONFIG_IMA_H */
+#endif /* CONFIG_IMA */
 
 #ifdef CONFIG_IMA_APPRAISE
 extern void ima_inode_post_setattr(struct dentry *dentry);
@@ -72,5 +72,5 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 {
 	return 0;
 }
-#endif /* CONFIG_IMA_APPRAISE_H */
+#endif /* CONFIG_IMA_APPRAISE */
 #endif /* _LINUX_IMA_H */
diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 66c5fe9..83222ce 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -36,5 +36,5 @@ static inline void integrity_inode_free(struct inode *inode)
 {
 	return;
 }
-#endif /* CONFIG_INTEGRITY_H */
+#endif /* CONFIG_INTEGRITY */
 #endif /* _LINUX_INTEGRITY_H */
-- 
1.7.11.7

