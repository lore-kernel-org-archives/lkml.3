Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaHSIb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:31:56 -0400
Received: from 59.163.222.168.static.vsnl.net.in ([59.163.222.168]:63846 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783AbaHSIby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:31:54 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2014 04:31:53 EDT
Date: Tue, 19 Aug 2014 04:21:54 -0400
From: Dipak Zope <dipakzope.kernel.org@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix checkpatch warning: Missing a blank line after
 declarations: drivers/staging/android/sync.c
Message-ID: <20140819082154.GA19196@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dipak Zope <dipakzope.kernel.org@gmail.com>
---
 drivers/staging/android/sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index e7b2e02..0d37495 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -705,6 +705,7 @@ static long sync_fence_ioctl(struct file *file, unsigned int cmd,
 			     unsigned long arg)
 {
 	struct sync_fence *fence = file->private_data;
+
 	switch (cmd) {
 	case SYNC_IOC_WAIT:
 		return sync_fence_ioctl_wait(fence, arg);
-- 
1.8.3.1

