Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3IKUlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:41:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41571 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460Ab3IKUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:41:49 -0400
X-Sasl-enc: nG0kKFMwiLJBoprCqKt0yEWu4bLGQns6e+hnOi2epQYq 1378932109
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, tao.peng@emc.com,
        jencce.kernel@gmail.com, wei.g.li@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: fix formatting mistake in Kconfig
Date: Wed, 11 Sep 2013 16:41:53 -0400
Message-Id: <1378932113-62708-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 4e898e4..f949728 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -16,7 +16,7 @@ config LUSTRE_FS
 	  this file system support as a module, choose M here: the module will
 	  be called lustre.
 
-	  To mount Lustre file systems , you also need to install the user space
+	  To mount Lustre file systems, you also need to install the user space
 	  mount.lustre and other user space commands which can be found in the
 	  lustre-client package, available from
 	  http://downloads.whamcloud.com/public/lustre/
-- 
1.8.4

