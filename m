Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaDCKE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 06:04:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42698 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaDCKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:04:55 -0400
Message-ID: <533d3246.82e6440a.77e1.ffffa143@mx.google.com>
From: Mike Sampson <mike@sambodata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Peng Tao <bergwolf@gmail.com>
CC: Masanari Iida <standby24x7@gmail.com>
CC: Andreas Dilger <andreas.dilger@intel.com>
CC: Kees Cook <keescook@chromium.org>
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
CC: trivial@kernel.org
Date: Thu, 3 Apr 2014 20:43:28 +1100
Subject: [PATCH] v3.14-7247-gcd6362b drivers/staging/lustre/lustre/libcfs/workitem.c  Fix sparse warning.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Sampson <mike@sambodata.com>

This fixes a sparse warning:
warning: symbol 'cfs_wi_data' was not declared. Should it be static?

---
 drivers/staging/lustre/lustre/libcfs/workitem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index ba16fd5..0a03bf7 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -75,7 +75,7 @@ typedef struct cfs_wi_sched {
 	char			ws_name[CFS_WS_NAME_LEN];
 } cfs_wi_sched_t;
 
-struct cfs_workitem_data {
+static struct cfs_workitem_data {
 	/** serialize */
 	spinlock_t		wi_glock;
 	/** list of all schedulers */
-- 
1.9.1
