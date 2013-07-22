Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790Ab3GVQVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:21:25 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35622 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3GVQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:16 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 17/48] staging/lustre/md: fix lu_ucred.c boilerplate
Date: Tue, 23 Jul 2013 00:06:38 +0800
Message-Id: <1374509230-3324-18-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In preparing Ie3a3cd99 (LU-1330 obdclass: splits server-side object
stack from client) the lu_ucred infrastructure was put in its own
file.  Fixup the boilerplate of this file to give the proper path,
short description, and authors.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1330
Lustre-change: http://review.whamcloud.com/5910
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/lu_ucred.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lu_ucred.c b/drivers/staging/lustre/lustre/obdclass/lu_ucred.c
index 229db6c..e23e545 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_ucred.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_ucred.c
@@ -33,13 +33,13 @@
  * This file is part of Lustre, http://www.lustre.org/
  * Lustre is a trademark of Sun Microsystems, Inc.
  *
- * lustre/obdclass/lu_object.c
+ * lustre/obdclass/lu_ucred.c
  *
- * Lustre Object.
- * These are the only exported functions, they provide some generic
- * infrastructure for managing object devices
+ * Lustre user credentials context infrastructure.
  *
  *   Author: Nikita Danilov <nikita.danilov@sun.com>
+ *   Author: Fan Yong <fan.yong@intel.com>
+ *   Author: Vitaly Fertman <vitaly_fertman@xyratex.com>
  */
 
 #define DEBUG_SUBSYSTEM S_CLASS
-- 
1.7.9.5

