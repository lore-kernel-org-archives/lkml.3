Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaH1LnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:43:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:64402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaH1LnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,417,1406617200"; 
   d="scan'208";a="473465526"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: james.l.morris@oracle.com, serge@hallyn.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] security: Silence shadow warning
Date: Thu, 28 Aug 2014 04:43:09 -0700
Message-Id: <1409226189-2369-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Renaming an unused formal parameter in the static inline function
security_inode_init_security eliminates many W=2 warnings.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/security.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 623f90e..3b3aeb1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2108,7 +2108,7 @@ static inline int security_dentry_init_security(struct dentry *dentry,
 static inline int security_inode_init_security(struct inode *inode,
 						struct inode *dir,
 						const struct qstr *qstr,
-						const initxattrs initxattrs,
+						const initxattrs xattrs,
 						void *fs_data)
 {
 	return 0;
-- 
1.9.3

