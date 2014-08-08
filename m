Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaHHJgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:36:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55906 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaHHJge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:36:34 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] driver core: Add missing parameter description to kerneldoc
Date: Fri,  8 Aug 2014 11:36:31 +0200
Message-Id: <1407490591-15754-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The deferred_probe_work_func() takes a single parameter but the
kerneldoc doesn't describe it.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note that since the function is locally scoped there isn't all that much
point in having a kerneldoc comment for it, but since it's already there
might as well make it correct.

 drivers/base/dd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e4ffbcf2f519..e8d417bb65bd 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -56,6 +56,7 @@ static atomic_t deferred_trigger_count = ATOMIC_INIT(0);
 
 /**
  * deferred_probe_work_func() - Retry probing devices in the active list.
+ * @work: work queue for deferred probe processing
  */
 static void deferred_probe_work_func(struct work_struct *work)
 {
-- 
2.0.4

