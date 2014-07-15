Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaGODcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:32:47 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:53860 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaGODco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:32:44 -0400
Date: Tue, 15 Jul 2014 00:32:35 -0300
From: Lucas Tanure <tanure@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: Clean up else statement from
 sync_fence_poll()
Message-ID: <20140715033235.GA29561@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel coding style. Remove useless else statement after return.

Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 drivers/staging/android/sync.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index c9a0c2c..e7b2e02 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -555,8 +555,7 @@ static unsigned int sync_fence_poll(struct file *file, poll_table *wait)
 		return POLLIN;
 	else if (status < 0)
 		return POLLERR;
-	else
-		return 0;
+	return 0;
 }
 
 static long sync_fence_ioctl_wait(struct sync_fence *fence, unsigned long arg)
-- 
2.0.1

